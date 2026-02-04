import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<User> login({
    required String username,
    required String password,
  }) async {
    final user = await _remoteDataSource.login(
      username: username,
      password: password,
    );
    await _localDataSource.saveUserSession(user);
    return user;
  }

  @override
  Future<User?> getSavedSession() {
    return _localDataSource.getUserSession();
  }

  @override
  Future<void> logout() {
    return _localDataSource.clearUserSession();
  }
}
