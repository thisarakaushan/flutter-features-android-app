// Packages
import 'package:flutter/material.dart';

// Widgets
import '../widgets/custom_button.dart';
import '../widgets/theme_switcher.dart';

class CounterThemeSwitcherScreen extends StatefulWidget {
  const CounterThemeSwitcherScreen({super.key});

  @override
  State<CounterThemeSwitcherScreen> createState() =>
      _CounterThemeSwitcherScreenState();
}

class _CounterThemeSwitcherScreenState
    extends State<CounterThemeSwitcherScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        actions: const [ThemeSwitcher()],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Counter: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            CustomButton(text: 'Increment', onPressed: _incrementCounter),
          ],
        ),
      ),
    );
  }
}
