import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle {
  const LoginWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<User> call() => _repository.loginWithGoogle();
}
