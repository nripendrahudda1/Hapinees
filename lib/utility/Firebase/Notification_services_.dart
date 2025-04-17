import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/main.dart';
import 'package:Happinest/modules/profile/notification/notification_screen.dart';
import 'package:Happinest/theme/app_colors.dart';
import 'package:Happinest/theme/theme.dart';

// Instance of FlutterLocalNotificationsPlugin for handling local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Function to navigate to a specific screen when a notification is tapped
void notificationontap(
  dynamic notificationResponse,
  String title,
  body,
) {
  log("Notification tap in app");
  flutterLocalNotificationsPlugin.cancel(1);
  navigatorKey.currentState!
      .push(MaterialPageRoute(builder: (context) => const NotificationScreen()))
      .then((value) {});
}

// Callback function for handling notification response when the app is in the foreground
void onDidReceiveNotificationResponse(NotificationResponse details) {
  log("Notification received and on tap");
  flutterLocalNotificationsPlugin.cancel(1);
  navigatorKey.currentState!
      .push(MaterialPageRoute(builder: (context) => const NotificationScreen()))
      .then((value) {});
}

// Callback function for handling notification response when the app is in the background
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) {
  log("Background notification and on tap");
  flutterLocalNotificationsPlugin.cancel(1);
  navigatorKey.currentState!
      .push(MaterialPageRoute(builder: (context) => const NotificationScreen()))
      .then((value) {});
}

class NotificationService {
  // Android initialization settings for local notifications
  final AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings("@mipmap/ic_launcher");

  final IOSFlutterLocalNotificationsPlugin iosFlutterLocalNotificationsPlugin =
      IOSFlutterLocalNotificationsPlugin();

  // iOS initialization settings for local notifications
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) =>
        onDidReceiveBackgroundNotificationResponse,
  );

  // Function to send a local notification
  void sendNotification(String title, String body, dynamic payload) async {
    // Android notification details
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Happinest', 'Happinest notification',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            color: TAppColors.appColor);

    // Notification details
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());

    // Show the notification and initialize notification service
    if (kDebugMode) {
      print('Shown notification to device');
    }
    await flutterLocalNotificationsPlugin.show(
        1, title, body, notificationDetails);
    initilizenotification(title, body, payload);
  }

  // Function to initialize the notification service
  void initilizenotification(String title, String body, dynamic payload) async {
    log("message 1");
    await _requestPermissions();
    log("message 2");
    // Initialization settings for local notifications
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  Future<void> _requestPermissions() async {
    try {
      if (Platform.isIOS) {
        // Request permissions for iOS
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      } else if (Platform.isAndroid) {
        // Request permissions for Android and create notification channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'Happinest',
          'Happinest notifications',
          importance: Importance.high,
          playSound: true,
          enableLights: true,
        );
        try {
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(channel);
          log('Notification channel created successfully.');
        } catch (e) {
          log('Error creating notification channel: $e');
        }
      }
      log('Notification permissions granted.');
    } catch (e) {
      log('Error requesting notification permissions: $e');
    }
  }
}
