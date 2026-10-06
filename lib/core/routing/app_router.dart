import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app_shell.dart';
import '../../app_state.dart';
import 'app_routes.dart';

/// GoRouter configuration — ready for Phase 3 navigation migration.
///
/// Currently unused; [AppShell] still handles routing via [AppState.route].
/// When migrating, replace `MaterialApp(home: AppShell())` with
/// `MaterialApp.router(routerConfig: AppRouter.create(appState))`.
abstract final class AppRouter {
  static GoRouter create(AppState appState) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      refreshListenable: appState,
      redirect: (context, state) {
        final loggedIn = appState.loggedIn;
        final location = state.matchedLocation;
        final isAuthRoute = location == AppRoutes.signup ||
            location == AppRoutes.forgotPassword ||
            location == AppRoutes.auth;

        if (!loggedIn && !isAuthRoute) {
          return AppRoutes.auth;
        }
        if (loggedIn && isAuthRoute) {
          return AppRoutes.home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AppShell(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Route not found: ${state.uri}'),
        ),
      ),
    );
  }
}
