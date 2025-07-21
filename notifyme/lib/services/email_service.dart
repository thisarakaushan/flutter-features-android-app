// Packages
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// Services
import '../services/preference_service.dart';

class EmailService {
  static Future<void> sendEmailNotification(BuildContext context) async {
    if (await PreferenceService.getNotificationPreference()) {
      // Simulate email sending locally (no API call)
      await Future.delayed(
        Duration(milliseconds: 500),
      ); // Simulate network delay
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email notification simulated and sent!')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Notifications are disabled')));
    }
  }
}

// class EmailService {
//   static Future<void> sendEmailNotification(BuildContext context) async {
//     if (await PreferenceService.getNotificationPreference()) {
//       try {
//         final response = await http.get(
//           Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
//         );
//         if (response.statusCode == 200) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text('Email notification sent!')));
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(
//                 'Failed to send email notification (HTTP ${response.statusCode})',
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         // Fallback: Simulate email success if network fails
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Email notification simulated (network error: $e)'),
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Notifications are disabled')));
//     }
//   }
// }
