import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void initNotification() {
    AwesomeNotifications().initialize(
      'resource://drawable/flutter_logo',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          criticalAlerts: true,
          importance: NotificationImportance.High,
        ),
      ],
    );

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications(permissions: const [
          NotificationPermission.Alert,
          NotificationPermission.Sound,
          NotificationPermission.Badge,
          NotificationPermission.Vibration,
          NotificationPermission.Light,
          NotificationPermission.PreciseAlarms,
        ]);
      }
    });
  }

  static Future<void> showNotification({
    int id = 0,
    String? name,
    String? title,
    String? description,
    String? body,
    String? payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title ?? name,
        body: body ?? description,
        payload: {'payload': payload ?? ''},
      ),
    );
  }

  static Future<void> scheduleNotification({
    int id = 0,
    String? name,
    String? title,
    String? description,
    String? body,
    String? payload,
    required DateTime scheduledNotificationDateTime,
  }) async {
    if (kDebugMode) {
      print('Scheduling notification at $scheduledNotificationDateTime');
    }

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title ?? name,
        body: body ?? description,
        payload: {'payload': payload ?? ''},
      ),
      schedule: NotificationCalendar.fromDate(
        date: scheduledNotificationDateTime,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );
  }

  static void testNotification() async {
    if (kDebugMode) {
      print('Attempting to send test notification...');
    }
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'basic_channel',
        title: 'Test Notification',
        body: 'This is a test notification.',
      ),
    );
    if (kDebugMode) {
      print('Test notification sent.');
    }
  }

  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
