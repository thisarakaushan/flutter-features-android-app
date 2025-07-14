// Packages
import 'package:flutter/material.dart';

// Screens
import '../screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User List App',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const UserListScreen(),
    );
  }
}
