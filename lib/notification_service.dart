import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Save Notification to Firestore**
  static Future<void> saveNotification({
    required String userUID,
    required String message,
    required String shopName,
  }) async {
    try {
      await _firestore.collection('notifications').add({
        'userUID': userUID,
        'shopName': shopName,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false, // Mark as unread
      });

      print("Notification saved to Firestore!");
    } catch (e) {
      print("Error saving notification: $e");
    }
  }

  /// **Send Push Notification using Firebase Cloud Messaging**
  static Future<void> sendPushNotification({
    required String userUID,
    required String title,
    required String body,
  }) async {
    try {
      // Fetch user's FCM token from Firestore
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(userUID).get();

      if (!userDoc.exists) {
        print("User not found");
        return;
      }

      String? fcmToken = userDoc['fcmToken'];
      if (fcmToken == null || fcmToken.isEmpty) {
        print("User does not have a valid FCM token");
        return;
      }

      String serverKey = "YOUR_FIREBASE_SERVER_KEY"; // Replace with your actual key

      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': fcmToken,
          'notification': {
            'title': title,
            'body': body,
            'sound': 'default',
          },
          'priority': 'high',
        }),
      );

      print("Push notification sent successfully!");
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }

  /// **Call this function to save & send a notification**
  static Future<void> notifyUser({
    required String userUID,
    required String shopName,
    required String message,
  }) async {
    await saveNotification(userUID: userUID, message: message, shopName: shopName);
    await sendPushNotification(userUID: userUID, title: "New Notification", body: message);
  }
}
