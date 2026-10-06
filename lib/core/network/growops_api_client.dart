import '../config/app_config.dart';
import '../errors/exceptions.dart';

/// HTTP client placeholder for the GrowOps Go Laravel backend.
///
/// Will be expanded with Dio in Phase 3 when auth is migrated.
class GrowOpsApiClient {
  GrowOpsApiClient({this.baseUrl = AppConfig.apiBaseUrl});

  static const defaultBaseUrl = AppConfig.apiBaseUrl;

  final String baseUrl;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError(
      'Connect Sanctum / Filament token auth to $baseUrl',
    );
  }

  /// Maps low-level errors to domain exceptions for repositories.
  Never rethrowAsAppException(Object error) {
    if (error is AppException) {
      throw error;
    }
    throw UnknownAppException(error);
  }
}
