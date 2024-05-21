import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:messaging_app/models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification,
        );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<void> scheduleNotification(Reminder reminder) async {
    DateTime scheduledNotificationDateTime = reminder.reminderTime.toDate();
    debugPrint('Scheduled notificstion for: $scheduledNotificationDateTime');
    
    var androidDetails = const AndroidNotificationDetails(
      'reminder_id',
      'Reminders',
      channelDescription: 'Channel for Reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker');

    var iOSDetails = const IOSNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    // ignore: deprecated_member_use
    await flutterLocalNotificationsPlugin.schedule(
        reminder.hashCode, // Using hashCode of reminder as a unique ID for the notification
        reminder.title,
        'Hey! Your reminder for ${reminder.title} is now!',
        scheduledNotificationDateTime,
        platformDetails,
        androidAllowWhileIdle: true);
  }

  Future<void> cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    // Handle reception of notification
  }

  Future selectNotification(String? payload) async {
    // Handle user tapping on a notification
  }
}
