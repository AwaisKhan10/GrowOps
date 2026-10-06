import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_state.dart';
import '../../../../core/di/injection.dart';
import '../auth_legacy_sync.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

/// Keeps legacy [AppState] in sync with [AuthBloc] during migration.
class AuthLegacyListener extends StatelessWidget {
  const AuthLegacyListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sync = AuthLegacySync(getIt<AppState>());

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => sync.sync(state),
      child: child,
    );
  }
}
