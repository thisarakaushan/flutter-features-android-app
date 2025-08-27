// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Bindings
import '../bindings/initial_binding.dart';

// Routes
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Collaborative Shopping List App',
      initialBinding: InitialBinding(),
      getPages: AppPages.routes,
      initialRoute: AppRoutes.SPLASH,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
