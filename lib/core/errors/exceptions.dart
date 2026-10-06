/// Low-level exceptions thrown by data sources.
/// Map these to [Failure] types in repositories.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

final class ServerException extends AppException {
  const ServerException({
    this.statusCode,
    String message = 'Server error',
  }) : super(message);

  final int? statusCode;
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

final class ValidationException extends AppException {
  const ValidationException([super.message = 'Validation error']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

final class ParsingException extends AppException {
  const ParsingException([super.message = 'Parsing error']);
}

final class AuthCancelledException extends AppException {
  const AuthCancelledException([super.message = 'Sign-in cancelled']);
}

final class UnknownAppException extends AppException {
  UnknownAppException(Object cause)
      : super('Unexpected error: $cause');
}
