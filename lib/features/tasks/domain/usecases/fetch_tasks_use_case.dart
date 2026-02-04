import '../entities/paginated_tasks.dart';
import '../repositories/task_repository.dart';

class FetchTasksUseCase {
  FetchTasksUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Future<PaginatedTasks> call({required int limit, required int skip}) {
    return _taskRepository.fetchTasks(limit: limit, skip: skip);
  }
}
