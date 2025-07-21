// Packages
import 'package:flutter/material.dart';

// Services
import '../services/notification_service.dart';
import '../services/email_service.dart';

// Widgets
import '../widgets/notification_button.dart';
// import '../widgets/toggle_switch.dart';

// Utils
import '../utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _scheduleNotification(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final TextEditingController titleController = TextEditingController();
      final TextEditingController bodyController = TextEditingController();
      final result = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Schedule Notification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Schedule'),
            ),
          ],
        ),
      );
      if (result == true) {
        final now = DateTime.now();
        final scheduledDateTime =
            DateTime(
              now.year,
              now.month,
              now.day,
              picked.hour,
              picked.minute,
            ).isBefore(now)
            ? DateTime(
                now.year,
                now.month,
                now.day + 1,
                picked.hour,
                picked.minute,
              )
            : DateTime(
                now.year,
                now.month,
                now.day,
                picked.hour,
                picked.minute,
              );
        print('Scheduled for: $scheduledDateTime');
        await NotificationService.scheduleNotification(
          scheduledDateTime,
          title: titleController.text.isNotEmpty
              ? titleController.text
              : 'Scheduled Notification',
          body: bodyController.text.isNotEmpty
              ? bodyController.text
              : 'This notification was scheduled!',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Notification scheduled for ${picked.format(context)} on ${scheduledDateTime.day}/${scheduledDateTime.month}/${scheduledDateTime.year}',
            ),
          ),
        );
        // Prompt to disable battery optimization
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please disable battery optimization in Settings > Apps > NotifyMe > Battery for notifications to work.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('NotifyMe'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Settings refreshed')));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              NotificationButton(
                label: 'Send Local Notification',
                onPressed: () => NotificationService.showLocalNotification(),
              ),
              NotificationButton(
                label: 'Schedule Notification',
                onPressed: () => _scheduleNotification(context),
              ),
              NotificationButton(
                label: 'Send Email Notification',
                onPressed: () => EmailService.sendEmailNotification(context),
              ),
              NotificationButton(
                label: 'Cancel All Notifications',
                onPressed: () => NotificationService.cancelAllNotifications(),
              ),
              // SizedBox(height: 20),
              // ToggleSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}
