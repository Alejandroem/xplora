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
}
