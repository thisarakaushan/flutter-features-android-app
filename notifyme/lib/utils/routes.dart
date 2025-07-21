// Packages
import 'package:flutter/material.dart';

// Screens
import '../screens/home_screen.dart';
import '../screens/notification_details_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String notificationDetails = '/notification-details';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    notificationDetails: (context) => const NotificationDetailsScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
