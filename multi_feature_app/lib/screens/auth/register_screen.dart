// Packages
import 'package:flutter/material.dart';

// Routes
import '../../routes.dart';

// Services
import '../../services/auth_service.dart';

// Utils
import '../../utils/validators.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _errorMessage;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signUp(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
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
      appBar: AppBar(title: const Text('Register')),
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
              CustomButton(text: 'Register', onPressed: _register),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
