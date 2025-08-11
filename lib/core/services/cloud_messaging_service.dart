import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


/// Initialize local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// Background message handler (Must be a top-level function)
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Background message received: ${message.messageId}");
}

/// Function to initialize Firebase Messaging
Future<void> setupFirebaseMessaging() async {
  try {
    const Duration defTimeout = Duration(seconds: 4);

    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission: ${settings.authorizationStatus}');
    } else {
      debugPrint('User denied or has not granted permission');
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.messageId}");
      showNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Handle when app is opened from a notification (terminated state)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint("App opened from terminated state: ${message.messageId}");
      }
    }).timeout(defTimeout);

    // Handle when app is opened from background (onResume)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("App opened from background: ${message.messageId}");
    });

    // Get and print FCM token (For debugging & sending test notifications)
    String? token = await FirebaseMessaging.instance.getToken().timeout(defTimeout);
    debugPrint("FCM Token: $token");
  } catch (e) {
    debugPrint(e.toString());
  }

}

/// Function to show local notifications
void showNotification(RemoteMessage message) async {
  AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
    icon: '@mipmap/ic_launcher',
  );

  NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    message.notification?.title ?? "No Title",
    message.notification?.body ?? "No Body",
    platformChannelSpecifics,
    payload: jsonEncode(message.data),
  );
}
