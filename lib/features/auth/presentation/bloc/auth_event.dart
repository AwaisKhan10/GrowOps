import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class LoginSubmitted extends AuthEvent {
  const LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class SignUpSubmitted extends AuthEvent {
  const SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

final class GoogleLoginRequested extends AuthEvent {
  const GoogleLoginRequested();
}

final class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

final class PasswordResetRequested extends AuthEvent {
  const PasswordResetRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

final class AuthFailureAcknowledged extends AuthEvent {
  const AuthFailureAcknowledged();
}

final class PasswordResetAcknowledged extends AuthEvent {
  const PasswordResetAcknowledged();
}
