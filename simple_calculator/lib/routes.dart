// Packages
import 'package:flutter/material.dart';

// Screens
import '../screens/home_screen.dart';
import '../screens/simple_calculator_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String calculator = '/simple-calculator';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    calculator: (context) => const SimpleCalculatorScreen(),
  };
}
