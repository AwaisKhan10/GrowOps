import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/guidance_step.dart';

/// Modal card matching the prototype STEP X OF 5 walkthrough.
class GuidanceCard extends StatelessWidget {
  const GuidanceCard({
    super.key,
    required this.stepIndex,
    required this.totalSteps,
    required this.step,
    required this.onNext,
    required this.onSkip,
    required this.onClose,
  });

  final int stepIndex;
  final int totalSteps;
  final GuidanceStep step;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onClose;

  bool get isLast => stepIndex >= totalSteps - 1;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.mint,
                  child: Icon(step.icon, color: AppColors.forest, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STEP ${stepIndex + 1} OF $totalSteps',
                        style: AppTextStyles.section().copyWith(fontSize: 11),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.title,
                        style: AppTextStyles.title().copyWith(
                          fontSize: 22,
                          color: AppColors.forest,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              step.body,
              style: AppTextStyles.body(color: AppColors.ink).copyWith(height: 1.35),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ...List.generate(totalSteps, (i) {
                  final active = i == stepIndex;
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    width: active ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active ? AppColors.forest : AppColors.line,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
                const Spacer(),
                TextButton(
                  onPressed: onSkip,
                  child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 4),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  ),
                  onPressed: onNext,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(isLast ? 'Got it' : 'Next'),
                      if (!isLast) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 16),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Dimmed overlay that hosts [GuidanceCard] over the shell.
class GuidanceOverlay extends StatelessWidget {
  const GuidanceOverlay({
    super.key,
    required this.stepIndex,
    required this.onNext,
    required this.onSkip,
    required this.onClose,
  });

  final int stepIndex;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final steps = GuidanceCatalog.steps;
    final step = steps[stepIndex.clamp(0, steps.length - 1)];

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.28),
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 72),
              child: GuidanceCard(
                stepIndex: stepIndex,
                totalSteps: steps.length,
                step: step,
                onNext: onNext,
                onSkip: onSkip,
                onClose: onClose,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
