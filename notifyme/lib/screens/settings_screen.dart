// Packages
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Services
import '../services/preference_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _isNotificationsEnabled =
        await PreferenceService.getNotificationPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: (value) async {
                  await PreferenceService.setNotificationPreference(value);
                  setState(() {
                    _isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await PreferenceService.setNotificationPreference(true);
                await NotificationService.cancelAllNotifications();
                setState(() {
                  _isNotificationsEnabled = true;
                });
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notifications enabled')),
                  );
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Notification preferences reset')),
                  );
                }
              },
              child: Text('Reset Notification Preferences'),
            ),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: Text('Open Notification Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
