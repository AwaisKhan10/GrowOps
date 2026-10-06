import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.workspace,
  });

  factory UserModel.demo({
    required String email,
    required String name,
    String workspace = 'Demo Farm',
  }) {
    return UserModel(
      id: 'demo-user',
      email: email,
      name: name,
      workspace: workspace,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      workspace: user.workspace,
    );
  }
}
