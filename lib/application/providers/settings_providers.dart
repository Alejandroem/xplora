import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/setting.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/settings_crud_service.dart';
import '../../infrastructure/services/firebase_settings_crud_service.dart';
import 'auth_providers.dart';

const _kIsDarkMode = 'isDarkMode';
const _kIsNotificationsEnabled = 'isNotificationsEnabled';

class SettingsStateNotifier extends StateNotifier<List<Setting>> {
  SettingsStateNotifier(
    this.settingsCrudService,
    this.authService,
  ) : super([]) {
    _init();
  }

  final SettingsCrudService settingsCrudService;
  final AuthService authService;

  void _init() async {
    final user = await authService.getAuthUser();

    if (user == null) {
      return;
    }

    final settings = await settingsCrudService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': user.id!,
      }
    ]);

    state = settings ?? [];
  }

  bool isDarkMode() {
    final darkModeIndex = state.indexWhere(
      (setting) => setting.key == _kIsDarkMode,
    );

    if (darkModeIndex == -1) {
      return false;
    }

    return state[darkModeIndex].value as bool;
  }

  bool isNotificationsEnabled() {
    final notificationsIndex = state.indexWhere(
      (setting) => setting.key == _kIsNotificationsEnabled,
    );

    if (notificationsIndex == -1) {
      return false;
    }

    return state[notificationsIndex].value as bool;
  }

  void toggleDarkMode() async {
    final darkModeIndex = state.indexWhere(
      (setting) => setting.key == _kIsDarkMode,
    );

    if (darkModeIndex == -1) {
      // Create new setting if it doesn't exist
      final user = await authService.getAuthUser();
      if (user == null) return;

      final newSetting = Setting(
        key: _kIsDarkMode,
        value: true,
        userId: user.id!,
        variableType: 'bool',
        updatedAt: DateTime.now(),
        id: null,
      );

      final created = await settingsCrudService.create(newSetting);
      if (created == null) return;

      state = [...state, created];
      return;
    }

    final currentDarkMode = state[darkModeIndex];

    await settingsCrudService.update(
      currentDarkMode.copyWith(
        value: !(currentDarkMode.value as bool),
      ),
      currentDarkMode.id!,
    );

    state = [
      ...state.sublist(0, darkModeIndex),
      currentDarkMode.copyWith(
        value: !(currentDarkMode.value as bool),
      ),
      ...state.sublist(darkModeIndex + 1),
    ];
  }

  void toggleNotifications() async {
    final notificationsIndex = state.indexWhere(
      (setting) => setting.key == _kIsNotificationsEnabled,
    );
    if (notificationsIndex == -1) {
      // Create new setting if it doesn't exist
      final user = await authService.getAuthUser();
      if (user == null) return;

      final newSetting = Setting(
        key: _kIsNotificationsEnabled,
        value: true,
        userId: user.id!,
        variableType: 'bool',
        updatedAt: DateTime.now(),
        id: null,
      );

      final created = await settingsCrudService.create(newSetting);
      if (created == null) return;

      state = [...state, created];
      return;
    }

    final currentNotifications = state[notificationsIndex];

    await settingsCrudService.update(
      currentNotifications.copyWith(
        value: !(currentNotifications.value as bool),
      ),
      currentNotifications.id!,
    );

    state = [
      ...state.sublist(0, notificationsIndex),
      currentNotifications.copyWith(
        value: !(currentNotifications.value as bool),
      ),
      ...state.sublist(notificationsIndex + 1),
    ];
  }
}

final settingsStateNotifierProvider =
    StateNotifierProvider<SettingsStateNotifier, List<Setting>>((ref) {
  return SettingsStateNotifier(
    ref.read(
      settingsCrudServiceProvider,
    ),
    ref.read(
      authServiceProvider,
    ),
  );
});

final settingsCrudServiceProvider = Provider<SettingsCrudService>(
  (ref) => FirebaseSettingsCrudService(),
);
