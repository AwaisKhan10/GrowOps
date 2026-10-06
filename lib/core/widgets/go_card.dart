import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class GoCard extends StatelessWidget {
  const GoCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final body = Material(
      color: AppColors.cardOf(context),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(color: AppColors.lineOf(context)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? AppSpacing.cardPadding,
        child: child,
      ),
    );
    if (onTap == null) return body;
    return GestureDetector(onTap: onTap, child: body);
  }
}
