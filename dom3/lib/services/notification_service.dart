import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';

import '../screens/meal_detail_screen.dart';
import '../main.dart'; 


String? _selectedNotificationPayload;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();


  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,

      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleNotificationClick(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) async {
        _handleNotificationClick(response.payload);
      },
    );

    tz.initializeTimeZones();
  }


  void _handleNotificationClick(String? payload) {
    if (payload == 'random_recipe') {
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(builder: (_) => const MealDetailScreen(random: true)),
        );
      } else {
        _selectedNotificationPayload = payload;
      }
    }
  }


  Future<NotificationAppLaunchDetails?> getInitialNotification() async {
    return await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }


  Future<void> scheduleDailyRecipeReminder() async {
    const int hour = 10;
    const int minute = 0;

    tz.TZDateTime _nextInstanceOfTenAM() {
      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
      return scheduledDate;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'daily_recipe_channel_id',
      'Daily Recipe Reminders',
      channelDescription: 'Reminder to check random recipe of the day',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '🎉 Recipe of the day!',
        'Click here to check today\'s random recipe!',
        _nextInstanceOfTenAM(),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'random_recipe');

    print('Daily notification scheduled for: $hour:$minute.');
  }



  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'test_channel_id',
      'Тест канал',
      channelDescription: 'Канал за брзо тестирање',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await _flutterLocalNotificationsPlugin.show(
        'Test Notification',
        'This is a test notification to prove it works :)',
        platformChannelSpecifics,
        payload: 'test_payload');
  }

}