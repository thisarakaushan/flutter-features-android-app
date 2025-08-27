// Pakcages
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

class RegisterPage extends StatelessWidget {
  final AuthController _controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
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
                        controller: usernameController,
                        label: 'Username',
                        validator: Validators.validateUsername,
                      ),
                      SizedBox(height: AppDimensions.paddingMedium),
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
                        text: 'Register',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _controller.register(
                              emailController.text,
                              passwordController.text,
                              usernameController.text,
                            );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () => Get.toNamed(AppRoutes.LOGIN),
                        child: Text('Already have an account? Login'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
