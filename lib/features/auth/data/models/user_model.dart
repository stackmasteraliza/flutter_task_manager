import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final token = (json['accessToken'] ?? json['token'] ?? '') as String;
    return UserModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: (json['email'] ?? '') as String,
      token: token,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'token': token,
    };
  }
}
