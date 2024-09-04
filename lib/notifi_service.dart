import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static void initNotification() {
    // Initialize Awesome Notifications
    AwesomeNotifications().initialize(
      'resource://drawable/flutter_logo', // Use app icon as the default icon
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

    // Request permissions
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Request permission
        AwesomeNotifications()
            .requestPermissionToSendNotifications(permissions: const [
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

  // Show an immediate notification
  static Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {'payload': payload ?? ''},
      ),
    );
  }

  // Schedule a notification
  static Future<void> scheduleNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledNotificationDateTime}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {'payload': payload ?? ''},
      ),
      schedule: NotificationCalendar.fromDate(
          date: scheduledNotificationDateTime, allowWhileIdle: true,preciseAlarm: true),
    );
  }

  // Cancel a notification
  static Future<void> cancelNotification(int id) async {
    await AwesomeNotifications().cancel(id);
  }
}
