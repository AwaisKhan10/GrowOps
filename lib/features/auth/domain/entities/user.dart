import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.workspace,
  });

  final String id;
  final String email;
  final String name;
  final String workspace;

  @override
  List<Object?> get props => [id, email, name, workspace];
}
