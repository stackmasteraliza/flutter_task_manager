import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:task_manager_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:task_manager_app/features/tasks/domain/entities/paginated_tasks.dart';
import 'package:task_manager_app/features/tasks/domain/entities/task.dart';
import 'package:task_manager_app/features/tasks/domain/usecases/add_task_use_case.dart';
import 'package:task_manager_app/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:task_manager_app/features/tasks/domain/usecases/fetch_tasks_use_case.dart';
import 'package:task_manager_app/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:task_manager_app/features/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/features/tasks/presentation/bloc/tasks_event.dart';
import 'package:task_manager_app/features/tasks/presentation/bloc/tasks_state.dart';

class _MockFetchTasksUseCase extends Mock implements FetchTasksUseCase {}

class _MockAddTaskUseCase extends Mock implements AddTaskUseCase {}

class _MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}

class _MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}

class _MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late FetchTasksUseCase fetchTasksUseCase;
  late AddTaskUseCase addTaskUseCase;
  late UpdateTaskUseCase updateTaskUseCase;
  late DeleteTaskUseCase deleteTaskUseCase;
  late AuthCubit authCubit;

  setUp(() {
    fetchTasksUseCase = _MockFetchTasksUseCase();
    addTaskUseCase = _MockAddTaskUseCase();
    updateTaskUseCase = _MockUpdateTaskUseCase();
    deleteTaskUseCase = _MockDeleteTaskUseCase();
    authCubit = _MockAuthCubit();

    when(() => authCubit.state).thenReturn(
      const AuthState(
        status: AuthStatus.authenticated,
        user: User(id: 1, username: 'u', email: 'e', token: 't'),
      ),
    );
  });

  blocTest<TasksBloc, TasksState>(
    'emits loading then success when tasks fetched',
    build: () {
      when(() => fetchTasksUseCase(limit: 10, skip: 0)).thenAnswer(
        (_) async => const PaginatedTasks(
          tasks: [Task(id: 1, todo: 'A', completed: false, userId: 1)],
          total: 1,
          skip: 0,
          limit: 10,
        ),
      );
      return TasksBloc(
        fetchTasksUseCase,
        addTaskUseCase,
        updateTaskUseCase,
        deleteTaskUseCase,
        authCubit,
      );
    },
    act: (bloc) => bloc.add(const TasksFetched()),
    expect: () => [
      const TasksState(status: TasksStatus.loading),
      const TasksState(
        status: TasksStatus.success,
        tasks: [Task(id: 1, todo: 'A', completed: false, userId: 1)],
        hasReachedMax: true,
      ),
    ],
  );

  blocTest<TasksBloc, TasksState>(
    'adds task to top of list on TaskAdded',
    build: () {
      when(
        () => addTaskUseCase(todo: 'New Task', userId: 1),
      ).thenAnswer(
        (_) async => const Task(id: 99, todo: 'New Task', completed: false, userId: 1),
      );
      return TasksBloc(
        fetchTasksUseCase,
        addTaskUseCase,
        updateTaskUseCase,
        deleteTaskUseCase,
        authCubit,
      );
    },
    seed: () => const TasksState(
      status: TasksStatus.success,
      tasks: [Task(id: 1, todo: 'A', completed: false, userId: 1)],
    ),
    act: (bloc) => bloc.add(const TaskAdded('New Task')),
    expect: () => [
      const TasksState(
        status: TasksStatus.success,
        tasks: [
          Task(id: 99, todo: 'New Task', completed: false, userId: 1),
          Task(id: 1, todo: 'A', completed: false, userId: 1),
        ],
      ),
    ],
  );
}
