import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_state.dart';
import '../core/feedback/app_snackbar.dart';
import '../core/theme/app_text_styles.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../theme.dart';
import '../widgets.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GoHeader(title: 'More'),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              const SectionLabel('Workspace'),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: AppColors.cardOf(context),
                      shape: StadiumBorder(
                        side: BorderSide(color: AppColors.lineOf(context)),
                      ),
                      child: InkWell(
                        onTap: () => app.go('/workspace'),
                        customBorder: const StadiumBorder(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: GoColors.forest,
                                child: Text(
                                  app.growerName.isNotEmpty
                                      ? app.growerName[0].toUpperCase()
                                      : 'D',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  app.workspace,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.inkOf(context),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(
                                Icons.unfold_more,
                                size: 18,
                                color: AppColors.mutedOf(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () => app.go('/workspace/invite'),
                    icon: const Icon(Icons.person_add_alt_outlined),
                    color: AppColors.inkOf(context),
                  ),
                  IconButton(
                    onPressed: () => app.go('/workspace'),
                    icon: const Icon(Icons.description_outlined),
                    color: AppColors.inkOf(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GoCard(
                onTap: () => app.go('/profile'),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: GoColors.forest,
                      child: Text(
                        app.growerName.isNotEmpty
                            ? app.growerName[0].toUpperCase()
                            : 'D',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            app.growerName,
                            style: AppTextStyles.title(
                              color: AppColors.inkOf(context),
                            ).copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            app.email,
                            style: TextStyle(
                              color: AppColors.mutedOf(context),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: GoColors.muted),
                  ],
                ),
              ),
              const SectionLabel('Plant care'),
              GoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    MenuRow(
                      label: 'Scan QR',
                      icon: Icons.qr_code_scanner,
                      route: '/scan',
                    ),
                    MenuRow(
                      label: 'Genetics',
                      icon: Icons.eco_outlined,
                      route: '/genetics',
                    ),
                    MenuRow(
                      label: 'Grow areas',
                      icon: Icons.place_outlined,
                      route: '/areas',
                      trailing: '${app.areas.length}',
                    ),
                    MenuRow(
                      label: 'Drying',
                      icon: Icons.air,
                      route: '/drying',
                    ),
                    MenuRow(
                      label: 'Curing',
                      icon: Icons.hourglass_bottom,
                      route: '/curing',
                    ),
                    MenuRow(
                      label: 'Packaging',
                      icon: Icons.inventory,
                      route: '/packaging',
                    ),
                  ],
                ),
              ),
              const SectionLabel('Sales'),
              const GoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    MenuRow(
                      label: 'Store orders',
                      icon: Icons.storefront_outlined,
                      route: '/sales/orders',
                    ),
                    MenuRow(
                      label: 'Invoices',
                      icon: Icons.receipt_long_outlined,
                      route: '/sales/invoices',
                    ),
                    MenuRow(
                      label: 'Clients',
                      icon: Icons.groups_outlined,
                      route: '/sales/clients',
                    ),
                    MenuRow(
                      label: 'Payments',
                      icon: Icons.payments_outlined,
                      route: '/sales/payments',
                    ),
                  ],
                ),
              ),
              const SectionLabel('Reports'),
              GoCard(
                onTap: () => app.go('/reports'),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.bar_chart,
                    color: AppColors.inkOf(context),
                  ),
                  title: Text(
                    'All reports',
                    style: AppTextStyles.body(
                      weight: FontWeight.w700,
                      color: AppColors.inkOf(context),
                    ),
                  ),
                  subtitle: Text(
                    'Cultivation · Inventory · Quality · Traceability · Waste · Dashboards',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.mutedOf(context),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.mutedOf(context),
                  ),
                ),
              ),
              const SectionLabel('Configure'),
              GoCard(
                onTap: () => app.go('/settings'),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.tune,
                    color: AppColors.inkOf(context),
                  ),
                  title: Text(
                    'Settings',
                    style: AppTextStyles.body(
                      weight: FontWeight.w700,
                      color: AppColors.inkOf(context),
                    ),
                  ),
                  subtitle: Text(
                    'Daily log fields · Strains · Rooms · Units',
                    style: AppTextStyles.bodySmall(
                      color: AppColors.mutedOf(context),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.mutedOf(context),
                  ),
                ),
              ),
              const SectionLabel('Settings'),
              GoCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.wb_sunny_outlined,
                        color: AppColors.inkOf(context),
                      ),
                      title: Text(
                        'Theme',
                        style: AppTextStyles.body(
                          color: AppColors.inkOf(context),
                        ),
                      ),
                      trailing: Text(
                        app.lightTheme ? 'Light' : 'Dark',
                        style: AppTextStyles.bodySmall(
                          color: AppColors.mutedOf(context),
                        ),
                      ),
                      onTap: () {
                        app.lightTheme = !app.lightTheme;
                        app.notifyListeners();
                      },
                    ),
                    Divider(height: 1, color: AppColors.lineOf(context)),
                    ListTile(
                      title: Text(
                        'Simulate offline',
                        style: AppTextStyles.body(
                          color: AppColors.inkOf(context),
                        ),
                      ),
                      trailing: Text(
                        app.offline ? 'Offline' : 'Online',
                        style: AppTextStyles.bodySmall(
                          color: AppColors.mutedOf(context),
                        ),
                      ),
                      onTap: app.toggleOffline,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _MoreActionButton(
                filled: true,
                icon: Icons.refresh,
                label: 'Reset demo data',
                onTap: () {
                  app.resetDemo();
                  AppSnackbar.showSuccess(context, 'Demo data reset');
                },
              ),
              const SizedBox(height: 10),
              _MoreActionButton(
                filled: false,
                icon: Icons.logout,
                label: 'Sign out · ${app.email}',
                onTap: () =>
                    context.read<AuthBloc>().add(const LogoutRequested()),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'GrowOps Go · prototype build',
                  style: AppTextStyles.bodySmall(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MoreActionButton extends StatelessWidget {
  const _MoreActionButton({
    required this.filled,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final bool filled;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled
          ? (AppColors.isDark(context)
              ? AppColors.darkCard
              : AppColors.inputFill)
          : AppColors.cardOf(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: filled
            ? BorderSide.none
            : BorderSide(color: AppColors.lineOf(context)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: AppColors.inkOf(context)),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body(
                    weight: FontWeight.w600,
                    color: AppColors.inkOf(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
