import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:reminder/repo/database_helper.dart';
import 'package:reminder/manager/work_manager.dart';
import 'package:reminder/route/app_page.dart';
import 'package:reminder/route/app_route.dart';
import 'package:reminder/screen/doughnut_graph.dart';
import 'package:reminder/service/notification_service.dart';
import 'package:reminder/theme/app_theme.dart';
import 'package:workmanager/workmanager.dart';

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
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: MediaQuery.of(context).platformBrightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      initialRoute: AppRoutes.dash,
      getPages: AppPages.pages,
    );
  }
}
