import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class TasksFetched extends TasksEvent {
  const TasksFetched();
}

class TasksRefreshed extends TasksEvent {
  const TasksRefreshed();
}

class TaskAdded extends TasksEvent {
  const TaskAdded(this.todo);

  final String todo;

  @override
  List<Object?> get props => [todo];
}

class TaskUpdated extends TasksEvent {
  const TaskUpdated(this.task);

  final Task task;

  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TasksEvent {
  const TaskDeleted(this.taskId);

  final int taskId;

  @override
  List<Object?> get props => [taskId];
}
