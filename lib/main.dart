import 'package:flutter/material.dart';
import 'package:reminder/remider_screen.dart';
import 'package:reminder/work_manager.dart';
import 'package:workmanager/workmanager.dart';

import 'notifi_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize notification service
  NotificationService.initNotification();

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReminderScreen(),
    );
  }
}
