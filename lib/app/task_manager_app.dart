import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/theme/app_theme.dart';
import '../di/injection.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/tasks/presentation/bloc/tasks_bloc.dart';
import 'app_router.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>()..bootstrap(),
        ),
        BlocProvider<TasksBloc>(
          create: (_) => getIt<TasksBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final appRouter = getIt<AppRouter>();
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Task Manager',
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: ThemeMode.system,
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
