import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  LocalStorageService(this._prefs);

  static const _cachedTasksKey = 'cached_tasks';

  final SharedPreferences _prefs;

  Future<void> saveCachedTasks(String tasksJson) async {
    await _prefs.setString(_cachedTasksKey, tasksJson);
  }

  String? getCachedTasks() {
    return _prefs.getString(_cachedTasksKey);
  }

  Future<void> clearCachedTasks() async {
    await _prefs.remove(_cachedTasksKey);
  }
}
