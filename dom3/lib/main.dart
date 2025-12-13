import 'package:dom2/screens/categories_screen.dart';
import 'package:dom2/screens/meal_detail_screen.dart';
import 'package:dom2/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


NotificationAppLaunchDetails? initialNotificationResponse;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final notificationService = NotificationService();
  await notificationService.init();
  notificationService.scheduleDailyRecipeReminder();
  notificationService.showTestNotification();


  initialNotificationResponse = await notificationService.getInitialNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    void navigateToRandomRecipe() {
      if (initialNotificationResponse?.didNotificationLaunchApp == true &&
          initialNotificationResponse?.notificationResponse?.payload == 'random_recipe')
      {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (_) => const MealDetailScreen(random: true)),
        );
      }
    }

    return MaterialApp(
      title: 'Meal App',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigateToRandomRecipe();
          });
          return const CategoriesScreen();
        },
      ),
    );
  }
}