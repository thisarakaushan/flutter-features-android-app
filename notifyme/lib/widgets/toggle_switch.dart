// Packages
import 'package:flutter/material.dart';

// Services
import '../services/preference_service.dart';

class ToggleSwitch extends StatefulWidget {
  const ToggleSwitch({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ToggleSwitchState createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  bool _isEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    _isEnabled = await PreferenceService.getNotificationPreference();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Notifications: '),
        Switch(
          value: _isEnabled,
          onChanged: (value) async {
            await PreferenceService.setNotificationPreference(value);
            setState(() {
              _isEnabled = value;
            });
          },
        ),
      ],
    );
  }
}
