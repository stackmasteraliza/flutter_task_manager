import '../../domain/entities/paginated_tasks.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final TaskRemoteDataSource _remoteDataSource;
  final TaskLocalDataSource _localDataSource;

  @override
  Future<PaginatedTasks> fetchTasks({required int limit, required int skip}) async {
    try {
      final result = await _remoteDataSource.fetchTasks(limit: limit, skip: skip);
      final cached = await _localDataSource.getTasks();
      final merged = _mergeTasks(
        existing: cached,
        incoming: result.tasks.map(TaskModel.fromEntity).toList(),
      );
      await _localDataSource.saveTasks(merged);
      return result;
    } catch (_) {
      if (skip != 0) {
        rethrow;
      }
      final cached = await _localDataSource.getTasks();
      return PaginatedTasks(
        tasks: cached,
        total: cached.length,
        skip: 0,
        limit: limit,
      );
    }
  }

  @override
  Future<Task> addTask({required String todo, required int userId}) async {
    final task = await _remoteDataSource.addTask(todo: todo, userId: userId);
    final cached = await _localDataSource.getTasks();
    await _localDataSource.saveTasks([task, ...cached]);
    return task;
  }

  @override
  Future<void> deleteTask(int taskId) async {
    final cached = await _localDataSource.getTasks();
    try {
      await _remoteDataSource.deleteTask(taskId);
    } catch (_) {
      // DummyJSON may return "id not found" for client-created todos.
    }
    await _localDataSource.saveTasks(cached.where((task) => task.id != taskId).toList());
  }

  @override
  Future<List<Task>> getCachedTasks() async {
    final tasks = await _localDataSource.getTasks();
    return tasks;
  }

  @override
  Future<Task> updateTask(Task task) async {
    final cached = await _localDataSource.getTasks();
    Task updatedTask;
    try {
      updatedTask = await _remoteDataSource.updateTask(TaskModel.fromEntity(task));
    } catch (_) {
      // Fallback for client-created todos not found remotely.
      updatedTask = task;
    }
    final updatedCached =
        cached.map((e) => e.id == updatedTask.id ? TaskModel.fromEntity(updatedTask) : e).toList();
    await _localDataSource.saveTasks(updatedCached);
    return updatedTask;
  }

  List<TaskModel> _mergeTasks({
    required List<TaskModel> existing,
    required List<TaskModel> incoming,
  }) {
    final map = <int, TaskModel>{
      for (final task in existing) task.id: task,
    };
    for (final task in incoming) {
      // Preserve local cache values when API returns stale/non-persistent data.
      map.putIfAbsent(task.id, () => task);
    }
    final values = map.values.toList();
    values.sort((a, b) => a.id.compareTo(b.id));
    return values;
  }
}
