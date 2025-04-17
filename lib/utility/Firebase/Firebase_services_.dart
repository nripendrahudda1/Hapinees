import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Happinest/utility/Firebase/Notification_services_.dart';
import 'package:Happinest/utility/constants/constants.dart';

// Function for handle firebase background notifiation
Future backgroundnotificationhandle(RemoteMessage remoteMessage) async {
  log("handle the background msg : ${remoteMessage.data}");
  log("Notifiation tap");
  NotificationService().sendNotification(
      remoteMessage.notification!.title.toString(),
      remoteMessage.notification!.body.toString(),
      remoteMessage.data);
}

class FirebaseService {
  // Initialize firebase for app
  static init() async {
    await Firebase.initializeApp(
            options: Platform.isIOS
                ? const FirebaseOptions(
                    apiKey: "AIzaSyBkCLxC8Uwg0RsryQmeaFgee-wNeWwESh0",
                    iosBundleId: "com.css.Happinest",
                    appId: "1:264121725875:ios:a7b4b15c61c8cd8b7f11c6",
                    messagingSenderId: "264121725875",
                    iosClientId:
                        "40572849204-ssq29k12phent04n4364p0qr80a3rjgp.apps.googleusercontent.com",
                    projectId: "happinest-c48d8")
                : Platform.isAndroid
                    ? const FirebaseOptions(
                        apiKey: "AIzaSyA10Ml8xhvNvpFgu09BWKSYCTOYvQisPLY",
                        appId: "1:264121725875:android:42f9b9a91fff67b97f11c6",
                        messagingSenderId: "264121725875",
                        projectId: "happinest-c48d8")
                    : null)
        .then((value) {
      log("firebase initialize complete");
    });
  }

  // Function for notificationInit
  static notificationInit() async {
    NotificationService notificationService = NotificationService();
    // try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // RequestPermission for send notifications
    await messaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
    // Get firebse fcmtoken for sending notification
    await messaging.getToken().then((value) {
      try {
        if (value != null) {
          fcmtoken = value;
          log('FCM token: $fcmtoken');
        } else {
          log("FCM token not found");
        }
      } catch (e) {
        log("FCM token retrival error ${e.toString()} ");
      }
    });
    // } catch (e) {
    //   log("error in firebase messaging == ${e.toString()}");
    // }

    // Handle onMessage notifications
    FirebaseMessaging.onMessage.listen((event) {
      notificationService.sendNotification(
          event.notification!.title ?? 'Careview',
          event.notification!.body ?? 'Info',
          event.data ?? {});
      log("notification onMessage recieved");
      log('title: ${event.notification!.title ?? ''}');
      log('body: ${event.notification!.body ?? ''}');
      log('data: ${event.data}');
    });

    // Handle onMessageOpenedApp notifications
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      notificationService.sendNotification(
          event.notification!.title ?? 'Careview',
          event.notification!.body ?? 'Info',
          event.data ?? {});
      log("notification onMessageOpendapp recieved");
      log('title: ${event.notification!.title ?? ''}');
      log('body: ${event.notification!.body ?? ''}');
      log('data: ${event.data}');
      log("notification event ${event.toString()}");
    });

    // Handle onBackgroundMessage notifications
    FirebaseMessaging.onBackgroundMessage(backgroundnotificationhandle);
  }

  // Handle and stupInteractedMessage notifications
  static Future<void> stupInteractedMessage() async {
    RemoteMessage? initialmessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialmessage != null) {
      NotificationService().sendNotification(
          initialmessage.notification!.title.toString() ?? "Happinest",
          initialmessage.notification!.body.toString() ??
              "Happinest notification",
          initialmessage.data ?? {});
    } else {
      log("No initialmessage message");
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      NotificationService().sendNotification(
          initialmessage!.notification!.title.toString() ?? "Happinest",
          initialmessage.notification!.body.toString() ??
              "Happinest notification",
          initialmessage.data ?? {});
    });
  }

}




// NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//     print('User granted permission: ${settings.authorizationStatus}');

//     if (Platform.isIOS) {
//       String? apnsToken;
//       try {
//         apnsToken = await messaging.getAPNSToken();
//         if (apnsToken == null) {
//           await Future.delayed(const Duration(seconds: 3));
//           apnsToken = await messaging.getAPNSToken();
//           print("after delay apnsToken = $apnsToken");
//         } else {
//           print("apnsToken = $apnsToken");
//         }
//       } catch (exception) {
//         print("exception = $exception");
//       }
//     }