import 'package:equatable/equatable.dart';

/// Base failure type for domain/presentation layers.
///
/// BLoCs emit [Failure] subtypes — not user-facing strings.
/// UI maps failures to localized messages.
sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure({this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [statusCode];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

final class ValidationFailure extends Failure {
  const ValidationFailure({this.field});

  final String? field;

  @override
  List<Object?> get props => [field];
}

final class CacheFailure extends Failure {
  const CacheFailure();
}

final class ParsingFailure extends Failure {
  const ParsingFailure();
}

final class UnknownFailure extends Failure {
  const UnknownFailure({this.cause});

  final Object? cause;

  @override
  List<Object?> get props => [cause];
}

/// Auth-specific failures for the auth feature.
sealed class AuthFailure extends Failure {
  const AuthFailure();
}

final class AuthInvalidCredentialsFailure extends AuthFailure {
  const AuthInvalidCredentialsFailure();
}

final class AuthInvalidEmailFailure extends AuthFailure {
  const AuthInvalidEmailFailure();
}

final class AuthSessionExpiredFailure extends AuthFailure {
  const AuthSessionExpiredFailure();
}

final class AuthCancelledFailure extends AuthFailure {
  const AuthCancelledFailure();
}
