import 'task.dart';

class PaginatedTasks {
  const PaginatedTasks({
    required this.tasks,
    required this.total,
    required this.skip,
    required this.limit,
  });

  final List<Task> tasks;
  final int total;
  final int skip;
  final int limit;
}
