import '../../../../core/network/api_client.dart';
import '../../domain/entities/paginated_tasks.dart';
import '../models/task_model.dart';

class TaskRemoteDataSource {
  TaskRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<PaginatedTasks> fetchTasks({required int limit, required int skip}) async {
    final response = await _apiClient.get(
      '/todos',
      queryParameters: {
        'limit': limit,
        'skip': skip,
      },
    );

    final todos = (response['todos'] as List<dynamic>)
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return PaginatedTasks(
      tasks: todos,
      total: response['total'] as int,
      skip: response['skip'] as int,
      limit: response['limit'] as int,
    );
  }

  Future<TaskModel> addTask({required String todo, required int userId}) async {
    final response = await _apiClient.post(
      '/todos/add',
      data: {
        'todo': todo,
        'completed': false,
        'userId': userId,
      },
    );

    return TaskModel.fromJson(response);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await _apiClient.put(
      '/todos/${task.id}',
      data: {
        'todo': task.todo,
        'completed': task.completed,
      },
    );

    return TaskModel.fromJson(response);
  }

  Future<void> deleteTask(int taskId) {
    return _apiClient.delete('/todos/$taskId');
  }
}
