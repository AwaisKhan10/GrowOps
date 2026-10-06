import '../../../app_state.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';

/// Syncs [AuthBloc] session state with legacy [AppState] during migration.
///
// TODO(migration): Remove after AppState is fully replaced.
class AuthLegacySync {
  AuthLegacySync(this._appState);

  final AppState _appState;

  void sync(AuthState state) {
    switch (state) {
      case AuthAuthenticated(:final user):
        _appState.email = user.email;
        _appState.growerName = user.name;
        _appState.workspace = user.workspace;
        if (!_appState.loggedIn) {
          _appState.login();
        }
      case AuthUnauthenticated():
        if (_appState.loggedIn) {
          _appState.logout();
        }
      case AuthPasswordResetSent():
      case AuthInitial():
      case AuthLoading():
      case AuthFailureState():
        break;
    }
  }
}
