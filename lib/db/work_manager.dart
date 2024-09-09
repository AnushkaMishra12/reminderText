import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    if (kDebugMode) {
      print('Background task running: $task');
    }
    return Future.value(true);
  });
}

void scheduleWork() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask(
    '1',
    'simpleTask',
    initialDelay: const Duration(seconds: 10),
  );
}