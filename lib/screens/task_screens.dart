import 'package:flutter/material.dart';

import '../app_state.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    // Match prototype Today list order (open first, then keep done in Completed).
    final todayOpen = app.tasks.where((t) => !t.done).take(3).toList();
    final completed = app.tasks.where((t) => t.done).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoHeader(title: 'Tasks', subtitle: '${todayOpen.length} open'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              const SectionLabel('Today', asTitle: true),
              GoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < todayOpen.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          indent: 52,
                          color: AppColors.lineOf(context),
                        ),
                      _OpenTaskRow(task: todayOpen[i]),
                    ],
                  ],
                ),
              ),
              const SectionLabel('Completed', asTitle: true),
              GoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (var i = 0; i < completed.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 1,
                          indent: 52,
                          color: AppColors.lineOf(context),
                        ),
                      _CompletedTaskRow(task: completed[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OpenTaskRow extends StatelessWidget {
  const _OpenTaskRow({required this.task});

  final GrowTask task;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  task.done = true;
                  app.notifyListeners();
                },
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.emphasisOf(context),
                      width: 1.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyles.body(
                        color: AppColors.inkOf(context),
                        weight: FontWeight.w700,
                      ).copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: () => app.go('/batches/${task.batchId}'),
                      child: Text(
                        task.batchLabel,
                        style: AppTextStyles.bodySmall(
                          color: AppColors.mutedOf(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Text(
                  'CONFIDENCE',
                  style: AppTextStyles.label(
                    color: AppColors.mutedOf(context),
                  ).copyWith(
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
                _ConfidenceChip(
                  label: 'Confident',
                  icon: Icons.thumb_up_alt_outlined,
                  selected: task.confidence == 'yes',
                  onTap: () {
                    task.confidence = 'yes';
                    app.notifyListeners();
                  },
                ),
                _ConfidenceChip(
                  label: 'Not confident',
                  icon: Icons.error_outline,
                  selected: task.confidence == 'no',
                  onTap: () {
                    task.confidence = 'no';
                    app.notifyListeners();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedTaskRow extends StatelessWidget {
  const _CompletedTaskRow({required this.task});

  final GrowTask task;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);

    return InkWell(
      onTap: () {
        task.done = false;
        app.notifyListeners();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(
                color: AppColors.forest,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.title,
                style: AppTextStyles.body(
                  color: AppColors.mutedOf(context),
                ).copyWith(
                  fontSize: 15,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.mutedOf(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfidenceChip extends StatelessWidget {
  const _ConfidenceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.isDark(context);
    final fg = selected
        ? (dark ? AppColors.darkInk : AppColors.forest)
        : AppColors.inkOf(context);
    return Material(
      color: selected
          ? (dark ? AppColors.forest : AppColors.mint)
          : AppColors.chipFillOf(context),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTextStyles.label(color: fg).copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
