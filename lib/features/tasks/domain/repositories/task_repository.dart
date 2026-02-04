import '../entities/paginated_tasks.dart';
import '../entities/task.dart';

abstract class TaskRepository {
  Future<PaginatedTasks> fetchTasks({required int limit, required int skip});

  Future<Task> addTask({required String todo, required int userId});

  Future<Task> updateTask(Task task);

  Future<void> deleteTask(int taskId);

  Future<List<Task>> getCachedTasks();
}
