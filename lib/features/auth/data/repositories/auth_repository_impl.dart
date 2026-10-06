import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/demo_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource);

  final DemoAuthDataSource _dataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.login(email: email, password: password);
    } on ValidationException {
      throw const AuthInvalidCredentialsFailure();
    } on AppException {
      throw const UnknownFailure();
    } catch (error) {
      throw UnknownFailure(cause: error);
    }
  }

  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await _dataSource.signUp(
        name: name,
        email: email,
        password: password,
      );
    } on ValidationException {
      throw const ValidationFailure();
    } on AppException {
      throw const UnknownFailure();
    } catch (error) {
      throw UnknownFailure(cause: error);
    }
  }

  @override
  Future<User> loginWithGoogle() async {
    try {
      return await _dataSource.loginWithGoogle();
    } on AuthCancelledException {
      throw const AuthCancelledFailure();
    } on UnauthorizedException {
      throw const UnauthorizedFailure();
    } on AppException {
      throw const UnknownFailure();
    } catch (error) {
      throw UnknownFailure(cause: error);
    }
  }

  @override
  Future<void> requestPasswordReset({required String email}) async {
    try {
      await _dataSource.requestPasswordReset(email: email);
    } on ValidationException {
      throw const AuthInvalidEmailFailure();
    } on AppException {
      throw const UnknownFailure();
    } catch (error) {
      throw UnknownFailure(cause: error);
    }
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }
}
