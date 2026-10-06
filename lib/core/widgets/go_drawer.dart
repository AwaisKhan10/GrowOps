import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app_state.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'section_label.dart';

class GoDrawer extends StatelessWidget {
  const GoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final route = app.route;
    final ink = AppColors.inkOf(context);
    final line = AppColors.lineOf(context);

    return Drawer(
      backgroundColor: AppColors.surfaceOf(context),
      width: MediaQuery.sizeOf(context).width * 0.82,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Menu',
                      style: AppTextStyles.display(color: ink)
                          .copyWith(fontSize: 28),
                    ),
                  ),
                  Material(
                    color: AppColors.softButtonOf(context),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => Navigator.pop(context),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(Icons.close, size: 22, color: ink),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: line),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                children: [
                  const SectionLabel('Main'),
                  _item(context, 'Home', Icons.home_outlined, '/',
                      selected: route == '/'),
                  _item(
                    context,
                    'Plant Batches',
                    Icons.spa_outlined,
                    '/batches',
                    selected: route.startsWith('/batches'),
                  ),
                  _item(
                    context,
                    'Tasks',
                    Icons.checklist_rtl,
                    '/tasks',
                    selected: route.startsWith('/tasks'),
                  ),
                  _item(
                    context,
                    'Stock',
                    Icons.inventory_2_outlined,
                    '/inventory',
                    selected: route.startsWith('/inventory'),
                  ),
                  _item(
                    context,
                    'More',
                    Icons.more_horiz,
                    '/more',
                    selected: route == '/more',
                  ),
                  const SectionLabel('Cultivation'),
                  _item(context, 'Grow Areas', Icons.place_outlined, '/areas'),
                  _item(
                    context,
                    'Genetics & Mothers',
                    Icons.science_outlined,
                    '/genetics',
                  ),
                  _item(context, 'Harvest', Icons.content_cut, '/harvest'),
                  _item(context, 'Drying', Icons.air, '/drying'),
                  _item(
                    context,
                    'Curing',
                    Icons.inventory_2_outlined,
                    '/curing',
                  ),
                  _item(
                    context,
                    'Packaging',
                    Icons.inventory_2_outlined,
                    '/packaging',
                  ),
                  const SectionLabel('Sales'),
                  _item(
                    context,
                    'Store Orders',
                    Icons.storefront_outlined,
                    '/sales/orders',
                  ),
                  _item(
                    context,
                    'Invoices',
                    Icons.receipt_long_outlined,
                    '/sales/invoices',
                  ),
                  _item(
                    context,
                    'New Invoice',
                    Icons.note_add_outlined,
                    '/sales/invoices/new',
                  ),
                  _item(
                    context,
                    'Clients',
                    Icons.groups_outlined,
                    '/sales/clients',
                  ),
                  _item(
                    context,
                    'Payments',
                    Icons.payments_outlined,
                    '/sales/payments',
                  ),
                  const SectionLabel('Reports'),
                  _item(context, 'Reports Hub', Icons.bar_chart, '/reports'),
                  const SectionLabel('Workspace'),
                  _item(
                    context,
                    'Workspace Settings',
                    Icons.apartment_outlined,
                    '/workspace',
                  ),
                  _item(context, 'Profile', Icons.person_outline, '/profile'),
                  _item(context, 'Scan QR', Icons.qr_code_scanner, '/scan'),
                  const SectionLabel('Settings'),
                  _item(
                    context,
                    'All settings',
                    Icons.settings_outlined,
                    '/settings',
                  ),
                  _item(
                    context,
                    'Daily Log fields',
                    Icons.tune,
                    '/settings/daily-log',
                  ),
                  _item(
                    context,
                    'Strains',
                    Icons.local_florist_outlined,
                    '/settings/strains',
                  ),
                  _item(
                    context,
                    'Rooms',
                    Icons.meeting_room_outlined,
                    '/settings/rooms',
                  ),
                  _item(
                    context,
                    'Inputs',
                    Icons.science_outlined,
                    '/settings/inputs',
                  ),
                  _item(
                    context,
                    'Units & Measurement',
                    Icons.straighten,
                    '/settings/units',
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: line),
            _SignOutTile(email: app.email),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    String label,
    IconData icon,
    String route, {
    bool selected = false,
  }) {
    final dark = AppColors.isDark(context);
    final color = selected
        ? (dark ? AppColors.mint : AppColors.forest)
        : AppColors.inkOf(context);
    final selectedBg = dark
        ? AppColors.forest.withValues(alpha: 0.35)
        : AppColors.mint;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? selectedBg : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            AppScope.of(context).go(route);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.body(
                      color: color,
                      weight: selected ? FontWeight.w700 : FontWeight.w500,
                    ).copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignOutTile extends StatelessWidget {
  const _SignOutTile({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final ink = AppColors.inkOf(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.pop(context);
            context.read<AuthBloc>().add(const LogoutRequested());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.logout, color: ink, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Sign out · $email',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body(
                      color: ink,
                      weight: FontWeight.w600,
                    ).copyWith(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
