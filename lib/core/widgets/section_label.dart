import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(
    this.text, {
    super.key,
    this.asTitle = false,
  });

  final String text;

  /// Large title style (Alerts / Today / Recent activity).
  final bool asTitle;

  @override
  Widget build(BuildContext context) {
    if (asTitle) {
      return Padding(
        padding: const EdgeInsets.only(top: 18, bottom: 10),
        child: Text(
          text,
          style: AppTextStyles.heading(color: AppColors.inkOf(context)),
        ),
      );
    }

    return Padding(
      padding: AppSpacing.sectionLabelPadding,
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.section(color: AppColors.mutedOf(context)),
      ),
    );
  }
}
