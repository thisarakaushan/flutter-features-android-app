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
        // Check email verification status
        final user = firebase_auth.FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email before proceeding.'),
              duration: Duration(seconds: 5),
            ),
          );
          // Optionally, you can poll for verification or wait for user action
          // For now, stay on this screen until verified
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('assets/default_profile_image.png')
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
                  decoration: const InputDecoration(labelText: 'Department'),
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
                  decoration: const InputDecoration(labelText: 'Education'),
                  validator: (value) =>
                      value == null ? 'Please select an education level' : null,
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
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Register',
                  onPressed: _register,
                  color: Colors.lightGreen[300],
                ),
                const SizedBox(height: 10),
                CustomButton(
                  text: 'Login Anonymously',
                  onPressed: () async {
                    try {
                      await _authService.signInAnonymously();
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
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
