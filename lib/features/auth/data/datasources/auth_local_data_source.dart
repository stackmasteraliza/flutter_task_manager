import 'dart:convert';

import '../../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._secureStorageService);

  final SecureStorageService _secureStorageService;

  Future<void> saveUserSession(UserModel user) {
    return _secureStorageService.saveSession(jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUserSession() async {
    final json = await _secureStorageService.getSession();
    if (json == null || json.isEmpty) {
      return null;
    }

    return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> clearUserSession() {
    return _secureStorageService.clearSession();
  }
}
