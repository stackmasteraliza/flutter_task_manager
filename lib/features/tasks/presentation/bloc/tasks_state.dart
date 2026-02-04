import 'package:equatable/equatable.dart';

import '../../domain/entities/task.dart';

enum TasksStatus { initial, loading, success, failure }

class TasksState extends Equatable {
  const TasksState({
    this.status = TasksStatus.initial,
    this.tasks = const <Task>[],
    this.hasReachedMax = false,
    this.errorMessage,
  });

  final TasksStatus status;
  final List<Task> tasks;
  final bool hasReachedMax;
  final String? errorMessage;

  TasksState copyWith({
    TasksStatus? status,
    List<Task>? tasks,
    bool? hasReachedMax,
    String? errorMessage,
  }) {
    return TasksState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, hasReachedMax, errorMessage];
}
