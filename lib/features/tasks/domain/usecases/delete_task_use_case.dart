import '../repositories/task_repository.dart';

class DeleteTaskUseCase {
  DeleteTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Future<void> call(int taskId) {
    return _taskRepository.deleteTask(taskId);
  }
}
