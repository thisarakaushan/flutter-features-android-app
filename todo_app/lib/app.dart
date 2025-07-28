// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Screens
import 'views/task_list_screen.dart';
import 'views/task_details_screen.dart';

// Bindings - DI
import 'bindings/task_binding.dart';

// Routes
import 'routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App with GetX',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // Set initial binding to inject dependencies
      initialBinding: TaskBinding(),
      // Define routes
      getPages: [
        GetPage(
          name: AppRoutes.taskList,
          page: () => const TaskListScreen(),
          binding: TaskBinding(),
        ),
        GetPage(
          name: AppRoutes.taskDetails,
          page: () => const TaskDetailsScreen(),
        ),
      ],
      // Set initial route
      initialRoute: AppRoutes.taskList,
      debugShowCheckedModeBanner: false,
    );
  }
}
