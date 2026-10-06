import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// Centralized SnackBar.
///
/// Sits in the upper content area, well below the status bar, so feedback
/// is readable and not flush with the system UI.
abstract final class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: AppColors.success,
      textColor: AppColors.forest,
    );
  }

  static void showError(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: AppColors.warning,
      textColor: AppColors.warningInk,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message,
      backgroundColor: AppColors.isDark(context)
          ? AppColors.darkCard
          : AppColors.ink,
      textColor: AppColors.isDark(context) ? AppColors.darkInk : Colors.white,
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
  }) {
    final media = MediaQuery.of(context);
    // Use viewPadding so status-bar inset is correct even inside SafeArea.
    // Extra 88px keeps the banner out of the status-bar / notch zone.
    final topInset = media.viewPadding.top + 88;
    const snackHeight = 64.0;
    final bottomMargin =
        (media.size.height - topInset - snackHeight).clamp(48.0, 9999.0);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: textColor ?? AppColors.ink,
              fontWeight: FontWeight.w600,
              height: 1.35,
              fontSize: 14,
            ),
          ),
          backgroundColor: backgroundColor ?? AppColors.ink,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.up,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
          elevation: 6,
        ),
      );
  }
}

/// In-form success or validation message. Place it next to the fields it
/// describes so it is not pushed against the status bar.
class AppMessageBanner extends StatelessWidget {
  const AppMessageBanner({
    super.key,
    required this.message,
    required this.isError,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final background = isError ? AppColors.warning : AppColors.success;
    final foreground = isError ? AppColors.warningInk : AppColors.forest;

    return Material(
      color: background,
      borderRadius: AppRadius.button,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              size: 18,
              color: foreground,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
