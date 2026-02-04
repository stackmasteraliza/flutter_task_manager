import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/task_manager_app.dart';
import 'di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await initDependencies();
  runApp(const TaskManagerApp());
}
