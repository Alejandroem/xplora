import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/setting.dart';
import '../../domain/services/settings_crud_service.dart';

class FirebaseSettingsCrudService implements SettingsCrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get the settings data document reference for a specific user
  /// Path: users/{userId}/settings/data
  DocumentReference<Map<String, dynamic>> _getUserSettingsDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('data');
  }

  /// Convert map entry to Setting object
  Setting _mapEntryToSetting(String userId, String key, dynamic value, DateTime updatedAt) {
    String variableType;
    if (value is bool) {
      variableType = 'bool';
    } else if (value is int) {
      variableType = 'int';
    } else if (value is double) {
      variableType = 'double';
    } else if (value is String) {
      variableType = 'string';
    } else {
      variableType = 'dynamic';
    }

    return Setting(
      id: key,
      userId: userId,
      key: key,
      value: value,
      variableType: variableType,
      updatedAt: updatedAt,
    );
  }

  @override
  Future<Setting> create(Setting entity) async {
    if (entity.userId.isEmpty) {
      throw Exception('userId is required to create a setting');
    }

    final docRef = _getUserSettingsDoc(entity.userId);
    final now = DateTime.now();

    // Get existing data or create new
    final snapshot = await docRef.get();
    final exists = snapshot.exists;

    Map<String, dynamic> updateData = {
      entity.key: entity.value,
      'updatedAt': now.toIso8601String(),
    };

    // Only set createdAt if document doesn't exist
    if (!exists) {
      updateData['createdAt'] = now.toIso8601String();
    }

    // Save to Firestore
    await docRef.set(updateData, SetOptions(merge: true));

    return entity.copyWith(updatedAt: now);
  }

  @override
  Future<Setting?> read(String id) async {
    throw UnimplementedError(
        'read(id) requires userId. Use readBy with userId filter.');
  }

  @override
  Future<Setting> updateOrCreate(Setting entity, String id) async {
    return await create(entity);
  }

  @override
  Future<List<Setting>> readBy(String field, String value) async {
    if (field == 'userId') {
      final docRef = _getUserSettingsDoc(value);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.data()!;
      final updatedAtStr = data['updatedAt'] as String?;
      final updatedAt = updatedAtStr != null
          ? DateTime.parse(updatedAtStr)
          : DateTime.now();

      List<Setting> settings = [];
      data.forEach((key, val) {
        if (key != 'createdAt' && key != 'updatedAt') {
          settings.add(_mapEntryToSetting(value, key, val, updatedAt));
        }
      });

      return settings;
    } else {
      throw UnimplementedError(
          'readBy is only supported for userId field');
    }
  }

  @override
  Future<Setting> update(Setting entity, String id) async {
    return await create(entity);
  }

  @override
  Future<void> delete(String id) async {
    throw UnimplementedError(
        'delete requires userId and key. Use deleteSetting(userId, key) instead.');
  }

  Future<void> deleteSetting(String userId, String key) async {
    final docRef = _getUserSettingsDoc(userId);
    final now = DateTime.now();

    await docRef.update({
      key: FieldValue.delete(),
      'updatedAt': now.toIso8601String(),
    });
  }

  Future<void> deleteAllSettings(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    await docRef.delete();
  }

  @override
  Future<List<Setting>> list() async {
    throw UnimplementedError(
        'list() is not supported. Use readBy with userId.');
  }

  @override
  Future<List<Setting>?> readByFilters(List<Map<String, dynamic>> filters) async {
    String? userId;

    for (final filter in filters) {
      if (filter['field'] == 'userId' && filter['operator'] == '==') {
        userId = filter['value'];
        break;
      }
    }

    if (userId == null) {
      throw Exception('userId filter is required for readByFilters');
    }

    return await readBy('userId', userId);
  }

  @override
  Stream<List<Setting>?> streamByFilters(List<Map<String, dynamic>> filters) {
    String? userId;

    for (final filter in filters) {
      if (filter['field'] == 'userId' && filter['operator'] == '==') {
        userId = filter['value'];
        break;
      }
    }

    if (userId == null) {
      throw Exception('userId filter is required for streamByFilters');
    }

    final docRef = _getUserSettingsDoc(userId);
    final userIdNonNull = userId; // Create non-nullable copy

    return docRef.snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.data()!;
      final updatedAtStr = data['updatedAt'] as String?;
      final updatedAt = updatedAtStr != null
          ? DateTime.parse(updatedAtStr)
          : DateTime.now();

      List<Setting> settings = [];
      data.forEach((key, val) {
        if (key != 'createdAt' && key != 'updatedAt') {
          settings.add(_mapEntryToSetting(userIdNonNull, key, val, updatedAt));
        }
      });

      return settings;
    });
  }

  @override
  Stream<Setting?> singleReadBy(String field, String value) async* {
    throw UnimplementedError(
        'singleReadBy is not supported. Use streamByFilters with userId.');
  }

  @override
  Stream<List<Setting>> listenBy(String field, String value) {
    if (field == 'userId') {
      return streamByFilters([
        {'field': 'userId', 'operator': '==', 'value': value}
      ]).map((settings) => settings ?? []);
    } else {
      throw UnimplementedError(
          'listenBy is only supported for userId field');
    }
  }

  @override
  Stream<Setting?> getStream(String id) async* {
    throw UnimplementedError(
        'getStream(id) is not supported. Use listenBy with userId.');
  }
}
