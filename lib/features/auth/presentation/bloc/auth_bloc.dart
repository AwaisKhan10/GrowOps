import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/login_with_google.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/request_password_reset.dart';
import '../../domain/usecases/sign_up_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUser loginUser,
    required SignUpUser signUpUser,
    required LoginWithGoogle loginWithGoogle,
    required LogoutUser logoutUser,
    required RequestPasswordReset requestPasswordReset,
  })  : _loginUser = loginUser,
        _signUpUser = signUpUser,
        _loginWithGoogle = loginWithGoogle,
        _logoutUser = logoutUser,
        _requestPasswordReset = requestPasswordReset,
        super(const AuthUnauthenticated()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
    on<AuthFailureAcknowledged>(_onAuthFailureAcknowledged);
    on<PasswordResetAcknowledged>(_onPasswordResetAcknowledged);
  }

  final LoginUser _loginUser;
  final SignUpUser _signUpUser;
  final LoginWithGoogle _loginWithGoogle;
  final LogoutUser _logoutUser;
  final RequestPasswordReset _requestPasswordReset;

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUser(
        email: event.email.trim(),
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on Failure catch (failure) {
      emit(AuthFailureState(failure));
    } catch (error) {
      emit(AuthFailureState(UnknownFailure(cause: error)));
    }
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _signUpUser(
        name: event.name.trim(),
        email: event.email.trim(),
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } on Failure catch (failure) {
      emit(AuthFailureState(failure));
    } catch (error) {
      emit(AuthFailureState(UnknownFailure(cause: error)));
    }
  }

  Future<void> _onGoogleLoginRequested(
    GoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _loginWithGoogle();
      emit(AuthAuthenticated(user));
    } on Failure catch (failure) {
      emit(AuthFailureState(failure));
    } catch (error) {
      emit(AuthFailureState(UnknownFailure(cause: error)));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUser();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onPasswordResetRequested(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _requestPasswordReset(email: event.email.trim());
      emit(const AuthPasswordResetSent());
    } on Failure catch (failure) {
      emit(AuthFailureState(failure));
    } catch (error) {
      emit(AuthFailureState(UnknownFailure(cause: error)));
    }
  }

  void _onAuthFailureAcknowledged(
    AuthFailureAcknowledged event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }

  void _onPasswordResetAcknowledged(
    PasswordResetAcknowledged event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthUnauthenticated());
  }
}
