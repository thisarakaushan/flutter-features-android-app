// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

// Utils
import '../../../core/utils/validators.dart';

// Widgets
import '../../../presentation/widgets/loading_widget.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  final AuthController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Obx(
          () => _controller.isLoading.value
              ? LoadingWidget()
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Reset Password',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _controller.resetPassword(emailController.text);
                          }
                        },
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
