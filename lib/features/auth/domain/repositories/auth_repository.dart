import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({
    required String email,
    required String password,
  });

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<User> loginWithGoogle();

  Future<void> requestPasswordReset({required String email});

  Future<void> logout();
}
