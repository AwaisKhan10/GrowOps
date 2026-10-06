import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class StageChip extends StatelessWidget {
  const StageChip(this.stage, {super.key, this.small = false});

  final String stage;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final (bg, ink) = _colorsForStage(stage);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? AppSpacing.sm : 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.chip,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            stage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.chip(color: ink, small: small),
          ),
        ],
      ),
    );
  }

  (Color, Color) _colorsForStage(String stage) {
    return switch (stage) {
      'Flower' => (AppColors.chipFlower, AppColors.chipFlowerInk),
      'Veg' => (AppColors.chipVeg, AppColors.chipVegInk),
      'Drying' => (AppColors.chipDry, AppColors.chipDryInk),
      'Seedling' || 'Rooting' => (AppColors.chipSeed, AppColors.chipSeedInk),
      'Harvested' => (AppColors.chipHarvest, AppColors.chipHarvestInk),
      'Curing' => (AppColors.chipCuring, AppColors.chipCuringInk),
      'Packaged' => (AppColors.chipPackaged, AppColors.chipPackagedInk),
      _ => (AppColors.mint, AppColors.forest),
    };
  }
}
