import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Bottom tab bar matching GrowOps prototype (outline icons, forest active).
class GoBottomNav extends StatelessWidget {
  const GoBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _items = <({IconData icon, String label})>[
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.spa_outlined, label: 'Batches'),
    (icon: Icons.checklist_rtl, label: 'Tasks'),
    (icon: Icons.inventory_2_outlined, label: 'Stock'),
    (icon: Icons.more_horiz, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardOf(context),
        border: Border(
          top: BorderSide(color: AppColors.lineOf(context), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _NavItem(
                    icon: _items[i].icon,
                    label: _items[i].label,
                    selected: selectedIndex == i,
                    onTap: () => onSelect(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Forest on dark bg has poor contrast — use mint when selected in dark.
    final selectedColor =
        AppColors.isDark(context) ? AppColors.mint : AppColors.forest;
    final color = selected ? selectedColor : AppColors.mutedOf(context);

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.label(color: color).copyWith(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
