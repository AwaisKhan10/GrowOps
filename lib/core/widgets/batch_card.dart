import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 'go_card.dart';
import 'soft_button.dart';
import 'stage_chip.dart';

enum BatchCardVariant {
  /// Home focus card: filled "Log today".
  home,

  /// Batches list card: soft "Log" + outlined "Move to …".
  list,

  /// Reports Active Batches: progress % + "Open batch →".
  report,
}

class BatchCard extends StatelessWidget {
  const BatchCard({
    super.key,
    required this.batch,
    this.compact = false,
    this.showMove = true,
    this.variant = BatchCardVariant.list,
  });

  final GrowBatch batch;
  final bool compact;
  final bool showMove;
  final BatchCardVariant variant;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final next = nextStageLabel(batch.stage);
    final isHome = variant == BatchCardVariant.home;

    return GoCard(
      onTap: () => app.go('/batches/${batch.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(
                  _stageIcon(batch.stage),
                  color: AppColors.inkOf(context),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.code,
                      style: AppTextStyles.batchCode(
                        color: AppColors.inkOf(context),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      batch.strain,
                      style: AppTextStyles.bodySmall(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              StageChip(batch.stage),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.spa_outlined,
                size: 15,
                color: AppColors.mutedOf(context),
              ),
              const SizedBox(width: 4),
              Text(
                variant == BatchCardVariant.report
                    ? '${batch.plants} plants'
                    : '${batch.plants}',
                style: AppTextStyles.bodySmall(
                  color: AppColors.mutedOf(context),
                ),
              ),
              _dot(context),
              if (variant == BatchCardVariant.report) ...[
                Icon(
                  Icons.place_outlined,
                  size: 14,
                  color: AppColors.mutedOf(context),
                ),
                const SizedBox(width: 2),
              ],
              Text(
                batch.area,
                style: AppTextStyles.bodySmall(
                  color: AppColors.mutedOf(context),
                ),
              ),
              _dot(context),
              Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: AppColors.mutedOf(context),
              ),
              const SizedBox(width: 4),
              Text(
                'Day ${batch.day}',
                style: AppTextStyles.bodySmall(
                  color: AppColors.mutedOf(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.progress,
            child: LinearProgressIndicator(
              value: batch.progress,
              minHeight: 6,
              color: AppColors.forest,
              backgroundColor: AppColors.lineOf(context),
            ),
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.md),
            if (variant == BatchCardVariant.report)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${(batch.progress * 100).round()}% of typical stage',
                      style: AppTextStyles.bodySmall(
                        color: AppColors.mutedOf(context),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => app.go('/batches/${batch.id}'),
                    child: Text(
                      'Open batch →',
                      style: AppTextStyles.body(
                        weight: FontWeight.w600,
                        color: AppColors.isDark(context)
                            ? AppColors.mint
                            : AppColors.forest,
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                children: [
                  SoftButton(
                    label: isHome ? 'Log today' : 'Log',
                    icon: Icons.edit_note,
                    filled: isHome,
                    flex: isHome ? 1 : 2,
                    onTap: () {
                      app.selectedBatchId = batch.id;
                      app.go('/log');
                    },
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  if (showMove)
                    SoftButton(
                      label: 'Move to ${moveToButtonLabel(next)}',
                      outlined: !isHome,
                      compact: true,
                      flex: 3,
                      onTap: () => app.advanceStage(batch),
                    ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _dot(BuildContext context) => Text(
        '  ·  ',
        style: AppTextStyles.bodySmall(color: AppColors.mutedOf(context)),
      );

  IconData _stageIcon(String stage) {
    return switch (stage) {
      'Flower' => Icons.local_florist_outlined,
      'Veg' => Icons.eco_outlined,
      'Drying' => Icons.air,
      'Curing' => Icons.inventory_2_outlined,
      'Harvested' => Icons.agriculture_outlined,
      'Packaged' => Icons.inventory_outlined,
      'Seedling' || 'Rooting' => Icons.spa_outlined,
      _ => Icons.grass_outlined,
    };
  }
}
