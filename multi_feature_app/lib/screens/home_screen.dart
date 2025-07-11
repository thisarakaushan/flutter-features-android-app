// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Routes
import '../routes.dart';

// Widgets
import '../widgets/custom_button.dart';
import '../widgets/theme_switcher.dart';

// Models
// import '../models/user_model.dart';

// Services
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _userDetails;

  // Initialize user details
  // This will be used to display user information in the profile dialog
  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  // Load user details from Firestore
  // This method fetches the current user's details from Firestore
  Future<void> _loadUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userDetails = doc.data();
      });
    }
  }

  // Save profile changes
  // This method saves the edited fields back to Firestore
  // Future<void> _saveField(String field, String value) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
  //       {field: value},
  //     );
  //     setState(() {
  //       _userDetails?[field] = value;
  //     });
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Profile updated successfully!')),
  //     );
  //   }
  // }

  void _showProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile'),
        content: _userDetails == null
            ? const Text('No details available')
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _userDetails!['profileImageUrl'] != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: CachedNetworkImageProvider(
                              _userDetails!['profileImageUrl'],
                            ),
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'assets/default_profile_image.png',
                            ),
                          ),
                    const SizedBox(height: 10),
                    Text(
                      'Name: ${_userDetails!['firstName']} ${_userDetails!['lastName']}',
                    ),
                    Text('Phone: ${_userDetails!['phone'] ?? ''}'),
                    Text('User Code: ${_userDetails!['userCode']}'),
                    Text('Email: ${_userDetails!['email']}'),
                    Text('Birthday: ${_userDetails!['birthday']}'),
                    Text(
                      'Department: ${_userDetails!['department'] ?? 'None'}',
                    ),
                    Text('Education: ${_userDetails!['education'] ?? 'None'}'),
                    Text('Gender: ${_userDetails!['gender']}'),
                    const SizedBox(height: 10),
                    Text('Password: ********'), // Placeholder for password
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _userDetails!['email'],
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password reset email sent! Check your inbox.',
                              ),
                            ),
                          );
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () async {
              await AuthService().signOut();
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text('Sign Out'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          const ThemeSwitcher(),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showProfile,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'To-Do List',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.todo),
              color: Colors.blue[400],
              isLoading: false,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'BMI Calculator',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.bmi),
              color: Colors.green[400],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Counter with Theme Switcher',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.counter),
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Contacts Manager',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.contacts),
              color: Colors.orange[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
