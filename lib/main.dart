import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/service/hive_service.dart";
import "package:copilot_poc/widgets/app.dart";
import "package:device_preview/device_preview.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setUpStorage();
  await fixPortrait();

  runApp(DevicePreview(builder: (_) => const App()));
}

/// Sets up the local storage service.
Future<void> setUpStorage() async {
  await HiveService<TaskModel>().init();
}

/// Sets the preferred orientations for the app to portrait mode only.
Future<void> fixPortrait() async {
  if (kIsWeb) {
    return;
  }
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
  ]);
}
