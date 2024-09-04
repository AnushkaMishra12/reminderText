import 'package:flutter/material.dart';
import 'package:reminder/remider_screen.dart';
import 'package:reminder/work_manager.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'notification_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  await NotificationHelper.createNotificationChannel();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  tz.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReminderScreen(),
    );
  }
}
