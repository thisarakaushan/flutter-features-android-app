// Packages
// import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_app_badge/flutter_app_badge.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

// Models
import '../models/notification_model.dart';

// Utils
import '../utils/constants.dart';
import '../utils/routes.dart';

// Services
import '../services/preference_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // Initialize timezone for scheduling
    tz.initializeTimeZones();

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          navigatorKey.currentState?.pushNamed(
            AppRoutes.notificationDetails,
            arguments: NotificationModel(
              title: 'Local Notification',
              body: response.payload ?? 'No Body',
              timestamp: DateTime.now(),
              type: 'Local',
            ),
          );
        }
      },
    );

    // Create Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      Constants.channelId,
      Constants.channelName,
      description: 'NotifyMe notifications',
      importance: Importance.high,
    );
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Firebase Messaging setup
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (await PreferenceService.getNotificationPreference()) {
        await _showLocalNotification(
          title: message.notification?.title ?? 'No Title',
          body: message.notification?.body ?? 'No Body',
          payload: message.notification?.body ?? '',
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Retrieve and log the FCM token
    String? token = await FirebaseMessaging.instance.getToken();
    print('FCM Token: $token');
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    if (await PreferenceService.getNotificationPreference()) {
      await _showLocalNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        payload: message.notification?.body ?? '',
      );
    }
  }

  static Future<void> _showLocalNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          Constants.channelId,
          Constants.channelName,
          importance: Importance.high,
          priority: Priority.high,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );
    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch % 1000,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  static Future<void> showLocalNotification() async {
    if (await PreferenceService.getNotificationPreference()) {
      await _showLocalNotification(
        title: 'Hello from NotifyMe',
        body: 'This is a local notification!',
        payload: 'Local notification payload',
      );
    }
  }

  static Future<void> scheduleNotification(
    DateTime scheduledTime, {
    String title = 'Scheduled Notification',
    String body = 'This notification was scheduled!',
  }) async {
    if (await PreferenceService.getNotificationPreference()) {
      final now = DateTime.now();
      print('Current time: $now');
      final scheduledDateTime =
          DateTime(
            now.year,
            now.month,
            now.day,
            scheduledTime.hour,
            scheduledTime.minute,
          ).isBefore(now)
          ? DateTime(
              now.year,
              now.month,
              now.day + 1,
              scheduledTime.hour,
              scheduledTime.minute,
            )
          : DateTime(
              now.year,
              now.month,
              now.day,
              scheduledTime.hour,
              scheduledTime.minute,
            );
      print('Scheduling notification for: $scheduledDateTime');
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            Constants.channelId,
            Constants.channelName,
            importance: Importance.high,
            priority: Priority.high,
          );
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );
      await _notificationsPlugin.zonedSchedule(
        DateTime.now().millisecondsSinceEpoch % 1000,
        title,
        body,
        tz.TZDateTime.from(scheduledDateTime, tz.local),
        platformDetails,
        payload: 'Scheduled notification payload',
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
