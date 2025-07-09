// Packages
import 'package:flutter/material.dart';

// Routes
import 'package:multi_feature_app/routes.dart';

// Services
import '../../services/auth_service.dart';

// Utils
import '../../utils/validators.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomInputField(
                controller: _emailController,
                label: 'Email',
                validator: Validators.validateEmail,
              ),
              CustomInputField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                validator: Validators.validatePassword,
              ),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              CustomButton(text: 'Login', onPressed: _login),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.register);
                },
                child: const Text('Don’t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
