// Packages
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

// Myapp
import './app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase if needed
  await Firebase.initializeApp();
  runApp(const MyApp());
}
