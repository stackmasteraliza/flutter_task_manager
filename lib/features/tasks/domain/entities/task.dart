import 'package:equatable/equatable.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  final int id;
  final String todo;
  final bool completed;
  final int userId;

  Task copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, todo, completed, userId];
}
