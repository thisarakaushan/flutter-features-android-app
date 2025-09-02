import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/module.dart';
import 'models/quiz_question.dart';
import 'screens/home_screen.dart';
import 'services/repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  // Initialize Hive
  await Hive.initFlutter(); //Initialize Hive for Flutter
  // Register Hive adapters
  Hive.registerAdapter(ModuleAdapter());
  Hive.registerAdapter(QuizQuestionAdapter());

  final repo = Repository();
  await repo.init(); // Init Hive

  // Sign in anonymously
  await FirebaseAuth.instance.signInAnonymously();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Offline LMS Sample',
      home: FutureBuilder(
        future: Repository().init(), // Defer repo init
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return HomeScreen();
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }
}
