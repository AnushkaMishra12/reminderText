import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:reminder/reminder_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'notification',
      'Reminder Notifications',
      description: 'Channel for reminder notifications',
      importance: Importance.max,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> scheduleNotification(Reminder reminder) async {
    final int notificationId =
        reminder.id ?? DateTime.now().millisecondsSinceEpoch;

    if (reminder.title.isEmpty || reminder.description.isEmpty) {
      throw ArgumentError('Reminder title or description cannot be empty');
    }

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'notification',
      'Reminder Notifications',
      channelDescription: 'Channel for reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        reminder.title,
        reminder.description,
        tz.TZDateTime.from(reminder.dateTime, tz.local),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      if (e is PlatformException && e.code == 'exact_alarms_not_permitted') {
        print(
            'Exact alarms are not permitted. Please check your app permissions.');
        print('PlatformException: ${e.message}');
      } else {
        print('Error scheduling notification: $e');
      }
    }
  }
}
