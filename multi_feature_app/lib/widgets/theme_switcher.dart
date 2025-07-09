// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// App
import '../app.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
        color: Theme.of(context).iconTheme.color,
      ),
      onPressed: () {
        themeProvider.toggleTheme();
      },
    );
  }
}
