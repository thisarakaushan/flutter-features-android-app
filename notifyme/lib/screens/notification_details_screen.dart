// Packages
import 'package:flutter/material.dart';

// Models
import '../models/notification_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  const NotificationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationModel? notification =
        ModalRoute.of(context)?.settings.arguments as NotificationModel?;

    return Scaffold(
      appBar: AppBar(title: Text('Notification Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notification == null
            ? Center(child: Text('No notification data'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${notification.title}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text('Body: ${notification.body}'),
                  SizedBox(height: 10),
                  Text('Timestamp: ${notification.timestamp.toString()}'),
                  SizedBox(height: 10),
                  Text('Type: ${notification.type}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Example action: Mark as read
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Marked as read')));
                    },
                    child: Text('Mark as Read'),
                  ),
                ],
              ),
      ),
    );
  }
}
