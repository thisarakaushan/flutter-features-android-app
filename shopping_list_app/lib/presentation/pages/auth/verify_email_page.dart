// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Services
import '../../../core/services/auth_service.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

// Widgets
import '../../../presentation/widgets/loading_widget.dart';

// Routes
import '../../../routes/app_routes.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';

class VerifyEmailPage extends StatelessWidget {
  final AuthController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Obx(
          () => _controller.isLoading.value
              ? LoadingWidget()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'A verification email has been sent to your email address.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: AppDimensions.paddingMedium),
                    CustomButton(
                      text: 'Resend Email',
                      onPressed: () async {
                        try {
                          await Get.find<AuthService>().auth.currentUser
                              ?.sendEmailVerification();
                          Get.snackbar('Success', 'Verification email resent');
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to resend email: $e');
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () => Get.offAllNamed(AppRoutes.LOGIN),
                      child: Text('Back to Login'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
