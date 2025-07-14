// Packages
import 'package:flutter/material.dart';

// Models
import '../models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final User user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.firstName} ${user.lastName}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Center avatar image and
        // Left-align user details
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.avatar),
              ),
            ),
            const SizedBox(height: 16),
            // Left-align user details
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
      // child: SingleChildScrollView(
      //   physics: const BouncingScrollPhysics(),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     CircleAvatar(
      //       radius: 50,
      //       backgroundImage: NetworkImage(user.avatar),
      //     ),
      //     const SizedBox(height: 16),
      //     Text(
      //       'Name: ${user.firstName} ${user.lastName}',
      //       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      //     ),
      //     const SizedBox(height: 8),
      //     Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
      //   ],
      // ),
    );
  }
}
