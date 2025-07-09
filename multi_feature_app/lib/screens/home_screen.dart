// Packages
import 'package:flutter/material.dart';

// Routes
import '../routes.dart';

// Widgets
import '../widgets/custom_button.dart';
import '../widgets/theme_switcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [ThemeSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'To-Do List',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.todo),
            ),
            CustomButton(
              text: 'BMI Calculator',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.bmi),
            ),
            CustomButton(
              text: 'Counter with Theme Switcher',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.counter),
            ),
            CustomButton(
              text: 'Contacts Manager',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
            ),
          ],
        ),
      ),
    );
  }
}
