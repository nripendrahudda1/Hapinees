import UIKit
import Flutter
import GoogleMaps
import flutter_local_notifications
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }
     GMSServices.provideAPIKey("AIzaSyAbVmKQJKXpj_ScWS82FeeTaNo8loxfJB8");
    //  GMSServices.provideAPIKey("AIzaSyAbVmKQJKXpj_ScWS82FeeTaNo8loxfJB8");
      //LocationManagerService.shared.delegate = self
      GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
      override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

       Messaging.messaging().apnsToken = deviceToken
       super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
