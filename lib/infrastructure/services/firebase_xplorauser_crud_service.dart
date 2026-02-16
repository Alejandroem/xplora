import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_crud_service.dart';

import '../../domain/models/xplora_user.dart';
import '../../domain/services/xplora_user_crud_service.dart';

class FirebaseXplorauserCrudService extends FirebaseCrudService<XploraUser>
    implements XploraUserService {
  final Duration _timeoutDuration = const Duration(seconds: 10);

  FirebaseXplorauserCrudService()
      : super(
          FirebaseFirestore.instance
              .collection('users')
              .withConverter<XploraUser>(
                fromFirestore: (snapshot, _) =>
                    XploraUser.fromJson(snapshot.data()!),
                toFirestore: (user, _) => user.toJson(),
              ),
        );

  @override
  Future<bool> isUsernameAvailable(String username) async {
    final querySnapshot = await _queryByUsername(username);
    return querySnapshot.docs.isEmpty;
  }

  @override
  Future<String?> getEmailByUsername(String username) async {
    final querySnapshot = await _queryByUsername(username);
    if (querySnapshot.docs.isEmpty) {
      return null;
    }
    return querySnapshot.docs.first.data()['email'] as String?;
  }

  /// Shared helper to query the users collection by username.
  Future<QuerySnapshot<Map<String, dynamic>>> _queryByUsername(
      String username) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get()
        .timeout(_timeoutDuration);
  }

  @override
  Future<void> updateName(String userId, String name) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'name': name}).timeout(_timeoutDuration);
  }

  @override
  Future<void> updateUsername(String userId, String username) async {
    final now = Timestamp.now();
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'username': username,
      'updatedAt': now,
    }).timeout(_timeoutDuration);
  }
}
