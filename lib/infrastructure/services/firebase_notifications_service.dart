import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../domain/services/firebase_notifications_service.dart';

class FirebaseNotificationsService extends NotificationsService {
  @override
  Future<void> saveToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      // Query to find if token already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('devices')
          .where('token', isEqualTo: token)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Token exists, update lastSeen
        await querySnapshot.docs.first.reference.update({
          'lastSeen': FieldValue.serverTimestamp(),
        });
      } else {
        // Token doesn't exist, create new document with userId
        await FirebaseFirestore.instance
            .collection('devices')
            .doc() // Auto-generate document ID
            .set({
          'userId': userId,
          'token': token,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  @override
  Future<void> sendNotificationToToken(
      String token, String title, String body) {
    // TODO: implement sendNotificationToToken
    throw UnimplementedError();
  }

  @override
  Future<void> sendNotificationToTopic(
      String topic, String title, String body) {
    // TODO: implement sendNotificationToTopic
    throw UnimplementedError();
  }

  @override
  Future<void> subscribeToTopic(String topic) {
    // TODO: implement subscribeToTopic
    throw UnimplementedError();
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) {
    // TODO: implement unsubscribeFromTopic
    throw UnimplementedError();
  }
}
