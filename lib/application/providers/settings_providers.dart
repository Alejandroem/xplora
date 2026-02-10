import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/services/auth_service.dart';
import 'auth_service_providers.dart';

class SettingsStateNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsStateNotifier(
    this.authService,
  ) : super({}) {
    _init();
  }

  final AuthService authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _init() async {
    final user = await authService.getAuthUser();

    if (user == null) {
      print('SettingsStateNotifier: No user found');
      return;
    }

    print('SettingsStateNotifier: Loading settings for user ${user.id}');

    try {
      final docSnapshot = await _firestore
          .collection('users')
          .doc(user.id!)
          .collection('settings')
          .doc('data')
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        print('SettingsStateNotifier: Loaded settings');
        state = data;
      }
    } catch (e) {
      print('SettingsStateNotifier: Error loading settings: $e');
    }
  }

  /// Get reference to user's settings document
  DocumentReference<Map<String, dynamic>> _getUserSettingsDoc(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('data');
  }

  bool? isDarkMode() {
    try {
      final accessibility = state['accessibility'] as Map<String, dynamic>?;
      if (accessibility == null) return null;
      return accessibility['dark_mode'] as bool?;
    } catch (e) {
      return null;
    }
  }

  bool isNotificationsEnabled() {
    try {
      final notifications = state['notifications'] as Map<String, dynamic>?;
      if (notifications == null) return false;
      return notifications['push_enabled'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  bool isLocationEnabled() {
    try {
      final permissions = state['permissions'] as Map<String, dynamic>?;
      if (permissions == null) return false;
      return permissions['location'] as bool? ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleDarkMode() async {
    final user = await authService.getAuthUser();
    if (user == null) return;

    final currentValue = isDarkMode() ?? false;
    final newValue = !currentValue;

    try {
      await _getUserSettingsDoc(user.id!).update({
        'accessibility.dark_mode': newValue,
        'updatedAt': Timestamp.now(),
      });

      // Update local state
      final newState = Map<String, dynamic>.from(state);
      if (newState['accessibility'] == null) {
        newState['accessibility'] = {};
      }
      (newState['accessibility'] as Map<String, dynamic>)['dark_mode'] = newValue;
      newState['updatedAt'] = Timestamp.now();
      state = newState;
    } catch (e) {
      print('Error toggling dark mode: $e');
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final user = await authService.getAuthUser();
    if (user == null) return;

    // Only update if value is different
    if (isNotificationsEnabled() == enabled) return;

    try {
      await _getUserSettingsDoc(user.id!).update({
        'notifications.push_enabled': enabled,
        'updatedAt': Timestamp.now(),
      });

      // Update local state
      final newState = Map<String, dynamic>.from(state);
      if (newState['notifications'] == null) {
        newState['notifications'] = {};
      }
      (newState['notifications'] as Map<String, dynamic>)['push_enabled'] = enabled;
      newState['updatedAt'] = Timestamp.now();
      state = newState;
    } catch (e) {
      print('Error setting notifications: $e');
    }
  }

  Future<void> toggleNotifications() async {
    final user = await authService.getAuthUser();
    if (user == null) return;

    final currentValue = isNotificationsEnabled();
    final newValue = !currentValue;

    try {
      await _getUserSettingsDoc(user.id!).update({
        'notifications.push_enabled': newValue,
        'updatedAt': Timestamp.now(),
      });

      // Update local state
      final newState = Map<String, dynamic>.from(state);
      if (newState['notifications'] == null) {
        newState['notifications'] = {};
      }
      (newState['notifications'] as Map<String, dynamic>)['push_enabled'] = newValue;
      newState['updatedAt'] = Timestamp.now();
      state = newState;

      // Request permission if enabling
      if (newValue) {
        await Permission.notification.request();
      }
    } catch (e) {
      print('Error toggling notifications: $e');
    }
  }

  Future<void> setLocationEnabled(bool enabled) async {
    final user = await authService.getAuthUser();
    if (user == null) return;

    // Only update if value is different
    if (isLocationEnabled() == enabled) return;

    try {
      await _getUserSettingsDoc(user.id!).update({
        'permissions.location': enabled,
        'updatedAt': Timestamp.now(),
      });

      // Update local state
      final newState = Map<String, dynamic>.from(state);
      if (newState['permissions'] == null) {
        newState['permissions'] = {};
      }
      (newState['permissions'] as Map<String, dynamic>)['location'] = enabled;
      newState['updatedAt'] = Timestamp.now();
      state = newState;
    } catch (e) {
      print('Error setting location: $e');
    }
  }

  Future<void> toggleLocation() async {
    final user = await authService.getAuthUser();
    if (user == null) return;

    final currentValue = isLocationEnabled();
    final newValue = !currentValue;

    try {
      await _getUserSettingsDoc(user.id!).update({
        'permissions.location': newValue,
        'updatedAt': Timestamp.now(),
      });

      // Update local state
      final newState = Map<String, dynamic>.from(state);
      if (newState['permissions'] == null) {
        newState['permissions'] = {};
      }
      (newState['permissions'] as Map<String, dynamic>)['location'] = newValue;
      newState['updatedAt'] = Timestamp.now();
      state = newState;

      // Request permission if enabling
      if (newValue) {
        await Permission.location.request();
      }
    } catch (e) {
      print('Error toggling location: $e');
    }
  }
}

final settingsStateNotifierProvider =
    StateNotifierProvider<SettingsStateNotifier, Map<String, dynamic>>((ref) {
  return SettingsStateNotifier(
    ref.read(authServiceProvider),
  );
});
