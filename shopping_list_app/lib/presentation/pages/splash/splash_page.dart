// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopping_list/presentation/widgets/loading_widget.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Routes
import '../../../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  final AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    _controller.authService.auth.authStateChanges().first.then((user) {
      if (user != null && user.emailVerified) {
        Get.offAllNamed(AppRoutes.DASHBOARD);
      } else {
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    });

    return Scaffold(body: Center(child: LoadingWidget()));
  }
}
