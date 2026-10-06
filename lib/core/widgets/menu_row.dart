import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class MenuRow extends StatelessWidget {
  const MenuRow({
    super.key,
    required this.label,
    required this.icon,
    required this.route,
    this.trailing,
  });

  final String label;
  final IconData icon;
  final String route;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final ink = AppColors.inkOf(context);
    final muted = AppColors.mutedOf(context);
    final accent =
        AppColors.isDark(context) ? AppColors.mint : AppColors.forest;

    return ListTile(
      leading: Icon(icon, color: accent),
      title: Text(
        label,
        style: AppTextStyles.body(weight: FontWeight.w600, color: ink),
      ),
      trailing: trailing == null
          ? Icon(Icons.chevron_right, color: muted)
          : Text(trailing!, style: AppTextStyles.bodySmall(color: muted)),
      onTap: () => AppScope.of(context).go(route),
    );
  }
}
