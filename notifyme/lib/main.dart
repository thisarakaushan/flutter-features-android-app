// Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

// Services
import '../services/notification_service.dart';
import '../services/preference_service.dart';

// Utils
import '../utils/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase if needed
  await Firebase.initializeApp();
  // print('Firebase initialized');

  await PreferenceService.init();
  await NotificationService.init();

  // Permission request is handled in SplashScreen, so no dialog here
  // Ensure notification permission is checked at startup
  PermissionStatus status = await Permission.notification.request();
  if (status.isDenied) {
    // Rely on SplashScreen to show the dialog
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'NotifyMe',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
