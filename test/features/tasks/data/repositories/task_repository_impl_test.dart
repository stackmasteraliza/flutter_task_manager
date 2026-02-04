import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_manager_app/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:task_manager_app/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_manager_app/features/tasks/data/models/task_model.dart';
import 'package:task_manager_app/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task_manager_app/features/tasks/domain/entities/paginated_tasks.dart';

class _MockTaskRemoteDataSource extends Mock implements TaskRemoteDataSource {}

class _MockTaskLocalDataSource extends Mock implements TaskLocalDataSource {}

void main() {
  late TaskRemoteDataSource remote;
  late TaskLocalDataSource local;
  late TaskRepositoryImpl repository;

  setUp(() {
    remote = _MockTaskRemoteDataSource();
    local = _MockTaskLocalDataSource();
    repository = TaskRepositoryImpl(remote, local);
  });

  test('fetchTasks caches remote result', () async {
    const remoteTasks = [
      TaskModel(id: 1, todo: 'A', completed: false, userId: 1),
    ];

    when(() => remote.fetchTasks(limit: 10, skip: 0)).thenAnswer(
      (_) async => const PaginatedTasks(tasks: remoteTasks, total: 1, skip: 0, limit: 10),
    );
    when(() => local.getTasks()).thenAnswer((_) async => <TaskModel>[]);
    when(() => local.saveTasks(any())).thenAnswer((_) async {});

    final result = await repository.fetchTasks(limit: 10, skip: 0);

    expect(result.tasks, remoteTasks);
    verify(() => local.saveTasks(any())).called(1);
  });

  test('deleteTask removes task from cache after remote delete', () async {
    when(() => remote.deleteTask(1)).thenAnswer((_) async {});
    when(() => local.getTasks()).thenAnswer(
      (_) async => const [
        TaskModel(id: 1, todo: 'A', completed: false, userId: 1),
        TaskModel(id: 2, todo: 'B', completed: false, userId: 1),
      ],
    );
    when(() => local.saveTasks(any())).thenAnswer((_) async {});

    await repository.deleteTask(1);

    final captured =
        verify(() => local.saveTasks(captureAny())).captured.single as List<TaskModel>;
    expect(captured.length, 1);
    expect(captured.first.id, 2);
  });
}
