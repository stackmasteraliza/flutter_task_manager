import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService(this._storage);

  static const _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  Future<void> saveSession(String sessionJson) {
    return _storage.write(key: _sessionKey, value: sessionJson);
  }

  Future<String?> getSession() {
    return _storage.read(key: _sessionKey);
  }

  Future<void> clearSession() {
    return _storage.delete(key: _sessionKey);
  }
}
