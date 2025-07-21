// Packages
import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const NotificationButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
          foregroundColor: Colors.black,
          backgroundColor: Colors.grey,
        ),
        child: Text(label),
      ),
    );
  }
}
