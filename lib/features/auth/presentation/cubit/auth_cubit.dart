import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_saved_session_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._loginUseCase,
    this._getSavedSessionUseCase,
    this._logoutUseCase,
  ) : super(const AuthState());

  final LoginUseCase _loginUseCase;
  final GetSavedSessionUseCase _getSavedSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> bootstrap() async {
    final savedUser = await _getSavedSessionUseCase();
    if (savedUser == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }

    emit(
      state.copyWith(status: AuthStatus.authenticated, user: savedUser),
    );
  }

  Future<void> login({required String username, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    if (kDebugMode) {
      debugPrint('[AuthCubit] login start username=$username');
    }
    try {
      final user = await _loginUseCase(username: username, password: password);
      if (kDebugMode) {
        debugPrint('[AuthCubit] login success userId=${user.id}');
      }
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthCubit] login failed error=$e');
      }
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
