// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Constants
import '../../../core/constants/app_dimensions.dart';

// Utils
import '../../../core/utils/validators.dart';

// Widgets
import '../../../presentation/widgets/loading_widget.dart';

// Routes
import '../../../routes/app_routes.dart';

// Controllers
import '../../controllers/auth_controller.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  final AuthController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
                      CustomButton(
                        text: 'Login',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _controller.login(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
                        child: Text('Forgot Password?'),
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.REGISTER),
                        child: Text('Create an Account'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
