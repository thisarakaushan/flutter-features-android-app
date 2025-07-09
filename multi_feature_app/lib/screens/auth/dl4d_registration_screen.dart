// Packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// Routes
import '../../routes.dart';

// Services
import '../../services/auth_service.dart';

// Utils
import '../../utils/validators.dart';

// Widgets
import '../../widgets/custom_button.dart';
import '../../widgets/custom_input_field.dart';

class DL4DRegistrationScreen extends StatefulWidget {
  const DL4DRegistrationScreen({super.key});

  @override
  State<DL4DRegistrationScreen> createState() => _DL4DRegistrationScreenState();
}

class _DL4DRegistrationScreenState extends State<DL4DRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _userCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  String? _birthday;
  String? _department = 'None';
  String? _education = 'None';
  String? _gender = 'Male';
  File? _profileImage;
  String? _errorMessage;
  bool _isVerifying = false; // State to show verification status and hide form

  final List<String> _departments = [
    'None',
    'HR',
    'IT',
    'Finance',
    'Marketing',
  ];
  final List<String> _educations = [
    'None',
    'High School',
    'Bachelor',
    'Master',
    'PhD',
  ];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    // Listen to auth state changes to detect email verification
    firebase_auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && user.emailVerified && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified! Redirecting to Home...'),
          ),
        );
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthday = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await _authService.resendVerificationEmail();
      setState(() {
        _errorMessage = 'Verification email resent. Please check your inbox.';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _checkVerificationStatus() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        setState(() {
          _isVerifying = false;
        });
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Redirecting to Home...'),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'Email not yet verified. Please check your inbox.';
        });
      }
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Passwords do not match';
        });
        return;
      }
      if (_emailController.text != _confirmEmailController.text) {
        setState(() {
          _errorMessage = 'Emails do not match';
        });
        return;
      }
      setState(() {
        _isVerifying = true;
        _errorMessage = null; // Clear any previous error message
      });
      try {
        await _authService.signUpWithDetails(
          _firstNameController.text,
          _lastNameController.text,
          _phoneController.text,
          _userCodeController.text,
          _emailController.text,
          _passwordController.text,
          _birthday ?? '',
          _department ?? 'None',
          _education ?? 'None',
          _gender ?? 'Male',
          _profileImage,
        );
        setState(() {
          _errorMessage =
              'A verification email has been sent to ${_emailController.text}. Please verify your email to proceed.';
        });
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
          _isVerifying = false;
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_isVerifying) // Show form only when not verifying
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage(
                                      'assets/default_profile_image.png',
                                    )
                                    as ImageProvider,
                          child: _profileImage == null
                              ? const Icon(Icons.camera_alt, size: 30)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomInputField(
                        controller: _firstNameController,
                        label: 'First Name',
                        icon: Icons.person,
                        validator: Validators.validateName,
                      ),
                      CustomInputField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        icon: Icons.person,
                        validator: Validators.validateName,
                      ),
                      CustomInputField(
                        controller: _phoneController,
                        label: 'Phone',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      CustomInputField(
                        controller: _userCodeController,
                        label: 'User Code',
                        icon: Icons.vpn_key,
                        validator: (value) => value == null || value.isEmpty
                            ? 'User Code is required'
                            : null,
                      ),
                      ListTile(
                        title: Text('Select Birthday'),
                        subtitle: Text(_birthday ?? 'No date chosen'),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () => _selectDate(context),
                      ),
                      DropdownButtonFormField<String>(
                        value: _department,
                        items: _departments.map((String department) {
                          return DropdownMenuItem<String>(
                            value: department,
                            child: Text(department),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _department = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Department',
                        ),
                        validator: (value) =>
                            value == null ? 'Please select a department' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _gender,
                        items: _genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _gender = newValue;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Gender'),
                        validator: (value) =>
                            value == null ? 'Please select a gender' : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: _education,
                        items: _educations.map((String education) {
                          return DropdownMenuItem<String>(
                            value: education,
                            child: Text(education),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _education = newValue;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Education',
                        ),
                        validator: (value) => value == null
                            ? 'Please select an education level'
                            : null,
                      ),
                      CustomInputField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        validator: Validators.validateEmail,
                      ),
                      CustomInputField(
                        controller: _confirmEmailController,
                        label: 'Confirm Email',
                        icon: Icons.email,
                        validator: (value) => value != _emailController.text
                            ? 'Emails do not match'
                            : null,
                      ),
                      CustomInputField(
                        controller: _passwordController,
                        label: 'Password',
                        icon: Icons.lock,
                        isPassword: true,
                        validator: Validators.validatePassword,
                      ),
                      CustomInputField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        icon: Icons.lock,
                        isPassword: true,
                        validator: (value) => value != _passwordController.text
                            ? 'Passwords do not match'
                            : null,
                      ),
                      if (_errorMessage != null && !_isVerifying)
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: 'Register',
                        onPressed: _register,
                        color: Colors.lightGreen[300],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Login Anonymously',
                        onPressed: () async {
                          try {
                            await _authService.signInAnonymously();
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              AppRoutes.home,
                            );
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Anonymous Login Successful!'),
                              ),
                            );
                          } catch (e) {
                            setState(() {
                              _errorMessage = e.toString();
                            });
                          }
                        },
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              if (_isVerifying)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        _errorMessage ??
                            'Verifying your email. Please wait or check your inbox.',
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Resend Verification Email',
                      onPressed: _resendVerificationEmail,
                      color: Colors.orange[300],
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Check Verification Status',
                      onPressed: _checkVerificationStatus,
                      color: Colors.blue[300],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _userCodeController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
