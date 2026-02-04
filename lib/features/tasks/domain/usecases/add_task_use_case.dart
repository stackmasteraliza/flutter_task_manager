import '../entities/task.dart';
import '../repositories/task_repository.dart';

class AddTaskUseCase {
  AddTaskUseCase(this._taskRepository);

  final TaskRepository _taskRepository;

  Future<Task> call({required String todo, required int userId}) {
    return _taskRepository.addTask(todo: todo, userId: userId);
  }
}
