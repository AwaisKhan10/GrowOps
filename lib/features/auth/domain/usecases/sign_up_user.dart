import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUser {
  const SignUpUser(this._repository);

  final AuthRepository _repository;

  Future<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.signUp(name: name, email: email, password: password);
  }
}
