// Packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  // Method for password reset
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter your email to reset password.';
      });
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
        ),
      );
    } catch (e) {
      String message = 'An error occurred';
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found with that email.';
            break;
          case 'invalid-email':
            message = 'Invalid email format.';
            break;
          case 'network-request-failed':
            message = 'Check your internet connection.';
            break;
          default:
            message = e.message ?? message;
        }
      }
      setState(() {
        _errorMessage = message;
      });
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, AppRoutes.home);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Login Successful!')));
      } catch (e) {
        String message = "An unknown error occurred";
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'invalid-credential':
              message = 'Invalid email or password';
              break;
            case 'user-not-found':
              message = 'No user found for that email';
              break;
            case 'wrong-password':
              message = 'Incorrect password';
              break;
            case 'network-request-failed':
              message = 'Check your internet connection';
              break;
            default:
              message = e.message ?? message;
          }
        }

        setState(() {
          _errorMessage = message;
        });

        // if (mounted) {
        //   ScaffoldMessenger.of(
        //     context,
        //   ).showSnackBar(SnackBar(content: Text(message)));
        // }
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
                onPressed: _resetPassword,
                child: const Text('Forgot Password?'),
              ),
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
