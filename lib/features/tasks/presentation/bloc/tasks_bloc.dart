import 'package:bloc/bloc.dart';

import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/entities/task.dart';
import '../../domain/usecases/add_task_use_case.dart';
import '../../domain/usecases/delete_task_use_case.dart';
import '../../domain/usecases/fetch_tasks_use_case.dart';
import '../../domain/usecases/update_task_use_case.dart';
import 'tasks_event.dart';
import 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(
    this._fetchTasksUseCase,
    this._addTaskUseCase,
    this._updateTaskUseCase,
    this._deleteTaskUseCase,
    this._authCubit,
  ) : super(const TasksState()) {
    on<TasksFetched>(_onFetched);
    on<TasksRefreshed>(_onRefreshed);
    on<TaskAdded>(_onAdded);
    on<TaskUpdated>(_onUpdated);
    on<TaskDeleted>(_onDeleted);
  }

  static const _pageSize = 10;

  final FetchTasksUseCase _fetchTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final AuthCubit _authCubit;

  Future<void> _onFetched(TasksFetched event, Emitter<TasksState> emit) async {
    if (state.hasReachedMax) {
      return;
    }

    final skip = state.tasks.length;
    if (skip == 0) {
      emit(state.copyWith(status: TasksStatus.loading, errorMessage: null));
    }

    try {
      final paginatedTasks = await _fetchTasksUseCase(limit: _pageSize, skip: skip);
      final newTasks = paginatedTasks.tasks;
      final allTasks = skip == 0 ? newTasks : [...state.tasks, ...newTasks];
      final hasReachedMax = allTasks.length >= paginatedTasks.total ||
          newTasks.length < _pageSize;

      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: allTasks,
          hasReachedMax: hasReachedMax,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          errorMessage: e.toString(),
          hasReachedMax: true,
        ),
      );
    }
  }

  Future<void> _onRefreshed(
    TasksRefreshed event,
    Emitter<TasksState> emit,
  ) async {
    final existingTasks = List<Task>.from(state.tasks);
    emit(const TasksState(status: TasksStatus.loading));
    try {
      final paginatedTasks = await _fetchTasksUseCase(limit: _pageSize, skip: 0);
      final mergedTasks = _mergeById(
        primary: existingTasks,
        secondary: paginatedTasks.tasks,
      );
      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: mergedTasks,
          hasReachedMax: mergedTasks.length >= paginatedTasks.total,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TasksStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  List<Task> _mergeById({
    required List<Task> primary,
    required List<Task> secondary,
  }) {
    final map = <int, Task>{for (final task in primary) task.id: task};
    for (final task in secondary) {
      // Keep local (primary) state on id conflicts because DummyJSON responses
      // are often non-persistent between requests.
      map.putIfAbsent(task.id, () => task);
    }
    return map.values.toList();
  }

  Future<void> _onAdded(TaskAdded event, Emitter<TasksState> emit) async {
    try {
      final user = _authCubit.state.user;
      if (user == null) {
        throw Exception('You must be logged in to add tasks.');
      }

      final task = await _addTaskUseCase(todo: event.todo, userId: user.id);
      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: [task, ...state.tasks],
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdated(TaskUpdated event, Emitter<TasksState> emit) async {
    try {
      final updatedTask = await _updateTaskUseCase(event.task);
      final updatedTasks = state.tasks
          .map((task) => task.id == updatedTask.id ? updatedTask : task)
          .toList();
      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: updatedTasks,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleted(TaskDeleted event, Emitter<TasksState> emit) async {
    try {
      await _deleteTaskUseCase(event.taskId);
      final updatedTasks = state.tasks
          .where((task) => task.id != event.taskId)
          .toList();
      emit(
        state.copyWith(
          status: TasksStatus.success,
          tasks: updatedTasks,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: TasksStatus.failure, errorMessage: e.toString()));
    }
  }
}
