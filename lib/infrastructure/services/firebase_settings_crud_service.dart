import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/setting.dart';
import '../../domain/services/settings_crud_service.dart';

class FirebaseSettingsCrudService implements SettingsCrudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Duration _timeoutDuration = const Duration(seconds: 10);

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
    final now = Timestamp.now();

    // Get existing data or create new
    final snapshot = await docRef.get().timeout(_timeoutDuration);
    final exists = snapshot.exists;

    Map<String, dynamic> updateData = {
      entity.key: entity.value,
      'updatedAt': now,
    };

    // Only set createdAt if document doesn't exist
    if (!exists) {
      updateData['createdAt'] = now;
    }

    // Save to Firestore
    await docRef.set(updateData, SetOptions(merge: true)).timeout(_timeoutDuration);

    return entity.copyWith(updatedAt: now as DateTime);
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
      final snapshot = await docRef.get().timeout(_timeoutDuration);

      if (!snapshot.exists) {
        return [];
      }

      final data = snapshot.data()!;
      final updatedAtTimestamp = data['updatedAt'] as Timestamp?;
      final updatedAt = updatedAtTimestamp?.toDate() ?? DateTime.now();

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

    await docRef.update({
      key: FieldValue.delete(),
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteAllSettings(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    await docRef.delete();
  }

  /// Creates default settings for a new user with grouped structure
  @override
  Future<void> createDefaultSettings({
    required String userId,
    required bool locationEnabled,
    required bool notificationsEnabled,
    required bool darkModeEnabled,
  }) async {
    final docRef = _getUserSettingsDoc(userId);
    final now = Timestamp.now();

    final settingsData = {
      'permissions': {
        'location': locationEnabled,
      },
      'notifications': {
        'push_enabled': notificationsEnabled,
      },
      'accessibility': {
        'dark_mode': darkModeEnabled,
      },
      'createdAt': now,
      'updatedAt': now,
    };

    await docRef.set(settingsData).timeout(_timeoutDuration);
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
      final updatedAtTimestamp = data['updatedAt'] as Timestamp?;
      final updatedAt = updatedAtTimestamp?.toDate() ?? DateTime.now();

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

  @override
  Future<List<Setting>?> readPaginated({
    required int limit,
    Setting? startAfter,
    List<Map<String, dynamic>>? filters,
  }) async {
    throw UnimplementedError(
        'readPaginated is not supported for Settings. Settings are stored in a single document per user.');
  }

  @override
  Future<Map<String, dynamic>> getSettings(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    final snapshot = await docRef.get().timeout(_timeoutDuration);

    if (!snapshot.exists) {
      return {};
    }

    return snapshot.data() ?? {};
  }

  @override
  Future<void> setLocationEnabled(String userId, bool enabled) async {
    final docRef = _getUserSettingsDoc(userId);

    await docRef.update({
      'permissions.location': enabled,
      'updatedAt': Timestamp.now(),
    }).timeout(_timeoutDuration);
  }

  @override
  Future<void> setNotificationsEnabled(String userId, bool enabled) async {
    final docRef = _getUserSettingsDoc(userId);

    await docRef.update({
      'notifications.push_enabled': enabled,
      'updatedAt': Timestamp.now(),
    }).timeout(_timeoutDuration);
  }

  @override
  Future<void> toggleDarkMode(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    final snapshot = await docRef.get().timeout(_timeoutDuration);

    if (!snapshot.exists) {
      throw Exception('Settings not found for user $userId');
    }

    final data = snapshot.data()!;
    final accessibility = data['accessibility'] as Map<String, dynamic>?;
    final currentValue = accessibility?['dark_mode'] as bool? ?? false;

    await docRef.update({
      'accessibility.dark_mode': !currentValue,
      'updatedAt': Timestamp.now(),
    }).timeout(_timeoutDuration);
  }

  @override
  Future<void> toggleNotifications(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    final snapshot = await docRef.get().timeout(_timeoutDuration);

    if (!snapshot.exists) {
      throw Exception('Settings not found for user $userId');
    }

    final data = snapshot.data()!;
    final notifications = data['notifications'] as Map<String, dynamic>?;
    final currentValue = notifications?['push_enabled'] as bool? ?? false;

    await docRef.update({
      'notifications.push_enabled': !currentValue,
      'updatedAt': Timestamp.now(),
    }).timeout(_timeoutDuration);
  }

  @override
  Future<void> toggleLocation(String userId) async {
    final docRef = _getUserSettingsDoc(userId);
    final snapshot = await docRef.get().timeout(_timeoutDuration);

    if (!snapshot.exists) {
      throw Exception('Settings not found for user $userId');
    }

    final data = snapshot.data()!;
    final permissions = data['permissions'] as Map<String, dynamic>?;
    final currentValue = permissions?['location'] as bool? ?? false;

    await docRef.update({
      'permissions.location': !currentValue,
      'updatedAt': Timestamp.now(),
    }).timeout(_timeoutDuration);
  }
}
