import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.token,
  });

  final int id;
  final String username;
  final String email;
  final String token;

  @override
  List<Object?> get props => [id, username, email, token];
}
