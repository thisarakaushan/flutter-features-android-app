// Packages
import 'package:flutter/material.dart';

// Screens
import '../screens/splash_screen.dart';
import '../screens/auth/login_screen.dart';
// import '../screens/auth/register_screen.dart';
import '../screens/auth/dl4d_registration_screen.dart';
import '../screens/home_screen.dart';
import '../screens/todo_screen.dart';
import '../screens/bmi_calculator_screen.dart';
import '../screens/counter_theme_switcher_screen.dart';
import '../screens/contacts_manager_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  // static const String register = '/register';
  static const String register = '/dl4d-register';
  static const String home = '/home';
  static const String todo = '/todo-list';
  static const String bmi = '/bmi-calculator';
  static const String counter = '/counter-theme-switcher';
  static const String contacts = '/contacts-manager';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    // register: (context) => const RegisterScreen(),
    register: (context) => const DL4DRegistrationScreen(),
    home: (context) => const HomeScreen(),
    todo: (context) => const TodoAppScreen(),
    bmi: (context) => const BMICalculatorScreen(),
    counter: (context) => const CounterThemeSwitcherScreen(),
    contacts: (context) => const ContactsManagerScreen(),
  };
}
