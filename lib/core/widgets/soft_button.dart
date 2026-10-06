import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

class SoftButton extends StatelessWidget {
  const SoftButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.trailingIcon,
    this.filled = false,
    this.outlined = false,
    this.compact = false,
    this.flex = 1,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool filled;
  final bool outlined;
  final bool compact;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final bg = filled
        ? AppColors.forest
        : outlined
            ? AppColors.cardOf(context)
            : AppColors.softButtonOf(context);
    final fg = filled ? Colors.white : AppColors.inkOf(context);
    final fontSize = compact ? 12.0 : 14.0;

    return Expanded(
      flex: flex,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.button,
          side: outlined
              ? BorderSide(color: AppColors.lineOf(context), width: 1.2)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.button,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: compact ? 6 : 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: compact ? 16 : 18, color: fg),
                  SizedBox(width: compact ? 4 : 6),
                ],
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.button(filled: filled, color: fg)
                          .copyWith(fontSize: fontSize),
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: compact ? 4 : 6),
                  Icon(trailingIcon, size: compact ? 14 : 16, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
