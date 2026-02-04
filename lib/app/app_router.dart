import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/tasks/presentation/pages/tasks_page.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter(this._authCubit);

  final AuthCubit _authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: '/tasks',
    refreshListenable: GoRouterRefreshStream(_authCubit.stream),
    redirect: (context, state) {
      final isLoggedIn = _authCubit.state.status == AuthStatus.authenticated;
      final isUnknown = _authCubit.state.status == AuthStatus.unknown;
      final isLoginRoute = state.matchedLocation == '/login';

      if (isUnknown) {
        return null;
      }
      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }
      if (isLoggedIn && isLoginRoute) {
        return '/tasks';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginPage(),
        ),
      ),
      GoRoute(
        path: '/tasks',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: TasksPage(),
        ),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      child: Scaffold(
        body: Center(
          child: Text('Route error: ${state.error}'),
        ),
      ),
    ),
  );
}
