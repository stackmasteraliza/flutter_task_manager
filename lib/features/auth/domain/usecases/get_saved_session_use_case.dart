import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class GetSavedSessionUseCase {
  GetSavedSessionUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<User?> call() {
    return _authRepository.getSavedSession();
  }
}
