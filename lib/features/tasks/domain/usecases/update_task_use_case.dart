import '../entities/task.dart';
import '../repositories/task_repository.dart';

class UpdateTaskUseCase {
  UpdateTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Future<Task> call(Task task) {
    return _taskRepository.updateTask(task);
  }
}
