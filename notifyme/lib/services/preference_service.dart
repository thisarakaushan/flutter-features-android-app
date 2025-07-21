// Packages
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _notificationKey = 'isNotificationsEnabled';

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_notificationKey)) {
      await prefs.setBool(_notificationKey, true); // Default: enabled
    }
  }

  static Future<bool> getNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationKey) ?? true;
  }

  static Future<void> setNotificationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationKey, value);
  }
}
