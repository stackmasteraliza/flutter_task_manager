import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/usecases/get_saved_session_use_case.dart';
import 'package:task_manager_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:task_manager_app/features/auth/domain/usecases/logout_use_case.dart';
import 'package:task_manager_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:task_manager_app/features/auth/presentation/cubit/auth_state.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase {}

class _MockGetSavedSessionUseCase extends Mock
    implements GetSavedSessionUseCase {}

class _MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late LoginUseCase loginUseCase;
  late GetSavedSessionUseCase getSavedSessionUseCase;
  late LogoutUseCase logoutUseCase;
  late User user;

  setUp(() {
    loginUseCase = _MockLoginUseCase();
    getSavedSessionUseCase = _MockGetSavedSessionUseCase();
    logoutUseCase = _MockLogoutUseCase();
    user = const User(id: 1, username: 'emilys', email: 'e@test.com', token: 't');
  });

  blocTest<AuthCubit, AuthState>(
    'emits authenticated when bootstrap finds session',
    build: () {
      when(() => getSavedSessionUseCase()).thenAnswer((_) async => user);
      return AuthCubit(loginUseCase, getSavedSessionUseCase, logoutUseCase);
    },
    act: (cubit) => cubit.bootstrap(),
    expect: () => [
      AuthState(status: AuthStatus.authenticated, user: user),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'emits loading then authenticated on successful login',
    build: () {
      when(
        () => loginUseCase(username: 'emilys', password: 'emilyspass'),
      ).thenAnswer((_) async => user);
      return AuthCubit(loginUseCase, getSavedSessionUseCase, logoutUseCase);
    },
    act: (cubit) => cubit.login(username: 'emilys', password: 'emilyspass'),
    expect: () => [
      const AuthState(status: AuthStatus.loading),
      AuthState(status: AuthStatus.authenticated, user: user),
    ],
  );
}
