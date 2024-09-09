import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'db/database_helper.dart';
import 'db/noti_service.dart';
import 'db/work_manager.dart';
import 'graph_habbit/doughnut_graph.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.database;
  await dbHelper.printTableStructure('habits');
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  NotificationService.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoughnutGraph(),
    );
  }
}
