import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
// Увези ги потребните фајлови за навигација и екранот
import '../screens/meal_detail_screen.dart'; // Претпоставена патека
import '../main.dart'; // За да пристапиме до navigatorKey

// Глобална променлива за чување на payload кога контекстот не е достапен
String? _selectedNotificationPayload;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // ********** ПОТРЕБНИ ИЗМЕНИ ВО init() **********
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
      // 1. Ракување кога апликацијата е отворена или во позадина
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleNotificationClick(response.payload);
      },
      // 2. Ракување кога се добива нотификација за време на интеракција (само iOS/macOS)
      onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) async {
        _handleNotificationClick(response.payload);
      },
    );

    tz.initializeTimeZones();
  }

  // ********** НОВ МЕТОД: Навигација **********
  // Функција која ја извршува навигацијата кога ќе се кликне нотификација
  void _handleNotificationClick(String? payload) {
    if (payload == 'random_recipe') {
      // Провери дали GlobalKey има валиден контекст
      if (navigatorKey.currentContext != null) {
        Navigator.of(navigatorKey.currentContext!).push(
          MaterialPageRoute(builder: (_) => const MealDetailScreen(random: true)),
        );
      } else {
        // Ако контекстот не е достапен (апликацијата се лансирала од 'terminated' состојба),
        // го зачувуваме payload-от за ракување во main.dart
        _selectedNotificationPayload = payload;
      }
    }
  }

  // ********** НОВ МЕТОД: Добивање на почетниот Payload **********
  // Ова се повикува во main.dart за да се провери дали апликацијата е отворена од нотификација
  Future<NotificationAppLaunchDetails?> getInitialNotification() async {
    return await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }


  // ... (Останатиот код за scheduleDailyRecipeReminder е непроменет)
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

  // Во class NotificationService

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
        1, // Различен ID од дневниот потсетник
        'Тест Нотификација',
        'Ова е тест нотификација што покажува дека системот работи.',
        platformChannelSpecifics,
        payload: 'test_payload');
  }

}