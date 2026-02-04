import 'package:flutter/foundation.dart';

import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    if (kDebugMode) {
      debugPrint('[AuthRemoteDataSource] login called for username=$username');
    }
    final response = await _apiClient.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
        'expiresInMins': 60,
      },
    );

    if (kDebugMode) {
      debugPrint(
        '[AuthRemoteDataSource] login success: id=${response['id']} username=${response['username']}',
      );
    }
    return UserModel.fromJson(response);
  }
}
