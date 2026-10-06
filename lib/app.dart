import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_shell.dart';
import 'app_state.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/widgets/auth_legacy_listener.dart';
import 'l10n/app_localizations.dart';

class GrowOpsGoApp extends StatefulWidget {
  const GrowOpsGoApp({super.key});

  @override
  State<GrowOpsGoApp> createState() => _GrowOpsGoAppState();
}

class _GrowOpsGoAppState extends State<GrowOpsGoApp> {
  late final AppState _state;

  @override
  void initState() {
    super.initState();
    _state = getIt<AppState>();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: BlocProvider<AuthBloc>.value(
        value: getIt<AuthBloc>(),
        child: AuthLegacyListener(
          child: AnimatedBuilder(
            animation: _state,
            builder: (context, _) {
              return MaterialApp(
                title: 'GrowOpsGo',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: _state.lightTheme ? ThemeMode.light : ThemeMode.dark,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppLocalizations.supportedLocales,
                home: const AppShell(),
              );
            },
          ),
        ),
      ),
    );
  }
}
