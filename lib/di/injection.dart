import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/app_router.dart';
import '../core/network/api_client.dart';
import '../core/storage/local_storage_service.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/datasources/auth_local_data_source.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/get_saved_session_use_case.dart';
import '../features/auth/domain/usecases/login_use_case.dart';
import '../features/auth/domain/usecases/logout_use_case.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/tasks/data/datasources/task_local_data_source.dart';
import '../features/tasks/data/datasources/task_remote_data_source.dart';
import '../features/tasks/data/repositories/task_repository_impl.dart';
import '../features/tasks/domain/repositories/task_repository.dart';
import '../features/tasks/domain/usecases/add_task_use_case.dart';
import '../features/tasks/domain/usecases/delete_task_use_case.dart';
import '../features/tasks/domain/usecases/fetch_tasks_use_case.dart';
import '../features/tasks/domain/usecases/update_task_use_case.dart';
import '../features/tasks/presentation/bloc/tasks_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));
  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<SecureStorageService>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GetSavedSessionUseCase>(
    () => GetSavedSessionUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      getIt<LoginUseCase>(),
      getIt<GetSavedSessionUseCase>(),
      getIt<LogoutUseCase>(),
    ),
  );

  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSource(getIt<LocalStorageService>()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(
      getIt<TaskRemoteDataSource>(),
      getIt<TaskLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<FetchTasksUseCase>(
    () => FetchTasksUseCase(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<AddTaskUseCase>(
    () => AddTaskUseCase(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(getIt<TaskRepository>()),
  );
  getIt.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(getIt<TaskRepository>()),
  );

  getIt.registerFactory<TasksBloc>(
    () => TasksBloc(
      getIt<FetchTasksUseCase>(),
      getIt<AddTaskUseCase>(),
      getIt<UpdateTaskUseCase>(),
      getIt<DeleteTaskUseCase>(),
      getIt<AuthCubit>(),
    ),
  );

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(getIt<AuthCubit>()),
  );
}
