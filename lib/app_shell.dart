import 'package:flutter/material.dart';
import 'app_state.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/onboarding/presentation/widgets/guidance_overlay.dart';
import 'screens/batch_screens.dart';
import 'screens/cultivation_screens.dart';
import 'screens/home_screen.dart';
import 'screens/more_screen.dart';
import 'screens/reports_screens.dart';
import 'screens/sales_screens.dart';
import 'screens/settings_screens.dart';
import 'screens/stock_screens.dart';
import 'screens/task_screens.dart';
import 'screens/workspace_screens.dart';
import 'widgets.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static const tabs = ['/', '/batches', '/tasks', '/inventory', '/more'];

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _drawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (!app.loggedIn) {
      if (app.route == '/forgot-password') return const ForgotPasswordPage();
      return AuthPage(initialSignup: app.route == '/signup');
    }

    final idx = AppShell.tabs.indexOf(app.route);
    final tabIndex = idx >= 0 ? idx : _guessTab(app.route);

    return Stack(
      children: [
        Scaffold(
          onEndDrawerChanged: (isOpen) {
            if (_drawerOpen == isOpen) return;
            setState(() => _drawerOpen = isOpen);
          },
          endDrawer: const GoDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(child: _pageFor(app.route)),
              ],
            ),
          ),
          bottomNavigationBar: GoBottomNav(
            selectedIndex: tabIndex,
            onSelect: (i) {
              if (app.showGuidance) return;
              app.go(AppShell.tabs[i]);
            },
          ),
        ),
        // Speed-dial FAB sits above the bottom nav (outside Scaffold FAB slot).
        // Hidden on form screens and while the menu is open, so it never
        // covers a primary action or Sign out.
        if (!_drawerOpen && !_hideFabForRoute(app.route))
          Positioned.fill(
            child: GoFabMenu(
              enabled: !app.showGuidance,
              actions: [
                GoFabAction(
                  label: 'Add log',
                  icon: Icons.description_outlined,
                  onTap: () => app.go('/log'),
                ),
                GoFabAction(
                  label: 'New batch',
                  icon: Icons.spa_outlined,
                  onTap: () => app.go('/new-batch'),
                ),
                GoFabAction(
                  label: 'Add photo',
                  icon: Icons.photo_camera_outlined,
                  onTap: () => app.go('/log'),
                ),
                GoFabAction(
                  label: 'Scan QR',
                  icon: Icons.qr_code_scanner,
                  onTap: () => app.go('/scan'),
                ),
                GoFabAction(
                  label: 'Harvest',
                  icon: Icons.content_cut,
                  onTap: () => app.go('/harvest'),
                ),
              ],
            ),
          ),
        if (app.showGuidance)
          GuidanceOverlay(
            stepIndex: app.guidanceStep,
            onNext: app.nextGuidanceStep,
            onSkip: app.completeGuidance,
            onClose: app.completeGuidance,
          ),
      ],
    );
  }

  bool _hideFabForRoute(String route) {
    const hideRoutes = {
      '/log',
      '/new-batch',
      '/harvest',
      '/scan',
      '/drying',
      '/curing',
      '/packaging',
      '/sales/invoices/new',
      '/sales/orders/new',
      '/profile',
    };
    return hideRoutes.contains(route) ||
        route.startsWith('/batches/') ||
        route.startsWith('/settings') ||
        route.startsWith('/reports/') ||
        route.startsWith('/sales/');
  }

  int _guessTab(String route) {
    if (route.startsWith('/batches')) return 1;
    if (route.startsWith('/tasks')) return 2;
    if (route.startsWith('/inventory')) return 3;
    if (route == '/') return 0;
    return 4;
  }

  Widget _pageFor(String route) {
    if (route == '/') return const HomeScreen();
    if (route == '/batches') return const BatchesScreen();
    if (route.startsWith('/batches/')) {
      return BatchDetailScreen(id: route.split('/').last);
    }
    if (route == '/tasks') return const TasksScreen();
    if (route == '/inventory') return const StockScreen();
    if (route.startsWith('/inventory/')) {
      return StockDetailScreen(id: route.split('/').last);
    }
    if (route == '/more') return const MoreScreen();
    if (route == '/log') return const QuickLogScreen();
    if (route == '/new-batch') return const NewBatchScreen();
    if (route == '/scan') return const ScanScreen();
    if (route == '/harvest') return const HarvestScreen();
    if (route == '/drying') return const DryingScreen();
    if (route == '/curing') return const CuringScreen();
    if (route == '/packaging') return const PackagingScreen();
    if (route == '/genetics') return const GeneticsScreen();
    if (route == '/areas') return const AreasScreen();
    if (route.startsWith('/areas/')) {
      return AreaDetailScreen(id: route.split('/').last);
    }
    if (route.startsWith('/mothers/')) {
      return MotherDetailScreen(id: route.split('/').last);
    }
    if (route.startsWith('/trace/')) {
      return TraceScreen(code: route.split('/').last);
    }
    if (route.startsWith('/sales')) return SalesRouter(route: route);
    if (route.startsWith('/reports')) return ReportsRouter(route: route);
    if (route.startsWith('/settings')) return SettingsRouter(route: route);
    if (route.startsWith('/workspace') || route == '/profile') {
      return WorkspaceRouter(route: route);
    }
    return const HomeScreen();
  }
}
