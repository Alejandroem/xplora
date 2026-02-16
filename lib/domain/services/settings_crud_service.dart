import '../models/setting.dart';
import 'crud_service.dart';

abstract class SettingsCrudService extends CrudService<Setting> {
  /// Creates default settings for a new user with grouped structure
  Future<void> createDefaultSettings({
    required String userId,
    required bool locationEnabled,
    required bool notificationsEnabled,
    required bool darkModeEnabled,
  });

  /// Get settings as a raw map for a user
  Future<Map<String, dynamic>> getSettings(String userId);

  /// Set location permission enabled/disabled
  Future<void> setLocationEnabled(String userId, bool enabled);

  /// Set notification permission enabled/disabled
  Future<void> setNotificationsEnabled(String userId, bool enabled);

  /// Toggle dark mode on/off
  Future<void> toggleDarkMode(String userId);

  /// Toggle notifications on/off
  Future<void> toggleNotifications(String userId);

  /// Toggle location on/off
  Future<void> toggleLocation(String userId);
}
