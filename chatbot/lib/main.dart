import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Screens
import '../screens/chat_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatbot App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/auth': (context) => AuthScreen(),
        '/chat': (context) => ChatScreen(),
      },
    );
  }
}
