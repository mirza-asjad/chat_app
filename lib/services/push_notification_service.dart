import 'package:firebase_messaging/firebase_messaging.dart';

class FCMManager {
  static Future<String> getFCMToken() async {
    // Request permission
    await FirebaseMessaging.instance.requestPermission();
    // Get the FCM token
    return await FirebaseMessaging.instance.getToken() ?? '';
  }
}
