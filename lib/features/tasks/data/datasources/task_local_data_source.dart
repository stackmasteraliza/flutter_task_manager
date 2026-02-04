import 'dart:convert';

import '../../../../core/storage/local_storage_service.dart';
import '../models/task_model.dart';

class TaskLocalDataSource {
  TaskLocalDataSource(this._localStorageService);

  final LocalStorageService _localStorageService;

  Future<void> saveTasks(List<TaskModel> tasks) {
    final tasksJson = tasks.map((e) => e.toJson()).toList();
    return _localStorageService.saveCachedTasks(jsonEncode(tasksJson));
  }

  Future<List<TaskModel>> getTasks() async {
    final json = _localStorageService.getCachedTasks();
    if (json == null || json.isEmpty) {
      return <TaskModel>[];
    }

    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
