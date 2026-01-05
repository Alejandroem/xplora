import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/xplora_profile_service.dart';

class FirebaseXploraProfileCrudService implements XploraProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<XploraProfile> create(XploraProfile entity) async {
    try {
      final profileData = entity.toJson();
      profileData['id'] = entity.userId; // Use userId as the document ID
      profileData['createdAt'] = DateTime.now().toUtc().toIso8601String();
      profileData['updatedAt'] = DateTime.now().toUtc().toIso8601String();

      await _firestore
          .collection('users')
          .doc(entity.userId)
          .collection('profile')
          .doc('data')
          .set(profileData, SetOptions(merge: true));

      return entity.copyWith(
        id: entity.userId,
        createdAt: profileData['createdAt'],
        updatedAt: profileData['updatedAt'],
      );
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<XploraProfile?> read(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(id)
          .collection('profile')
          .doc('data')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        data['id'] = id; // Ensure id is set
        return XploraProfile.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to read profile: $e');
    }
  }

  @override
  Future<XploraProfile> update(XploraProfile entity, String id) async {
    try {
      final profileData = entity.toJson();
      profileData['id'] = id;
      profileData['updatedAt'] = DateTime.now().toUtc().toIso8601String();

      await _firestore
          .collection('users')
          .doc(id)
          .collection('profile')
          .doc('data')
          .set(profileData, SetOptions(merge: true));

      return entity.copyWith(
        id: id,
        updatedAt: profileData['updatedAt'],
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(id)
          .collection('profile')
          .doc('data')
          .delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  @override
  Future<List<XploraProfile>> readBy(String field, String value) async {
    try {
      if (field == 'userId') {
        final profile = await read(value);
        return profile != null ? [profile] : [];
      }
      
      // For other fields, we'd need to query across all users
      // This is not efficient for subcollections, so we'll limit this functionality
      throw UnimplementedError('Querying by $field is not supported for user subcollections');
    } catch (e) {
      throw Exception('Failed to read profiles by $field: $e');
    }
  }

  @override
  Future<List<XploraProfile>> list() async {
    throw UnimplementedError('Listing all profiles is not supported for user subcollections');
  }

  @override
  Stream<XploraProfile?> getStream(String id) {
    return _firestore
        .collection('users')
        .doc(id)
        .collection('profile')
        .doc('data')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        data['id'] = id;
        return XploraProfile.fromJson(data);
      }
      return null;
    });
  }

  @override
  Future<XploraProfile> updateOrCreate(XploraProfile entity, String id) async {
    final existing = await read(id);
    if (existing != null) {
      return update(entity, id);
    } else {
      return create(entity);
    }
  }

  @override
  Future<List<XploraProfile>?> readByFilters(List<Map<String, dynamic>> filters) async {
    throw UnimplementedError('Filtering profiles is not supported for user subcollections');
  }

  @override
  Stream<List<XploraProfile>?> streamByFilters(List<Map<String, dynamic>> filters) {
    throw UnimplementedError('Streaming filtered profiles is not supported for user subcollections');
  }

  @override
  Stream<XploraProfile?> singleReadBy(String field, String value) {
    if (field == 'userId') {
      return getStream(value);
    }
    throw UnimplementedError('Single read by $field is not supported for user subcollections');
  }

  @override
  Stream<List<XploraProfile>> listenBy(String field, String value) {
    if (field == 'userId') {
      return getStream(value).map((profile) => profile != null ? [profile] : []);
    }
    throw UnimplementedError('Listen by $field is not supported for user subcollections');
  }

  @override
  Future<List<XploraProfile>?> readPaginated({
    required int limit,
    XploraProfile? startAfter,
    List<Map<String, dynamic>>? filters,
  }) async {
    throw UnimplementedError(
        'readPaginated is not supported for user subcollections. Profiles are stored as individual documents per user.');
  }
}
