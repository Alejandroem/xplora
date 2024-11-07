import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/local_storage_service.dart';
import 'local_storage_providers.dart';

class SettingsStateNotifier extends StateNotifier<Map<String, dynamic>> {
  SettingsStateNotifier(this.localStorageService) : super(<String, bool>{}) {
    _init();
  }

  final LocalStorageService localStorageService;

  void _init() async {
    final isDarkMode = bool.tryParse(
      await localStorageService.read(
            'isDarkMode',
          ) ??
          'false',
    );
    final isNotificationsEnabled = bool.tryParse(
      await localStorageService.read(
            'isNotificationsEnabled',
          ) ??
          'false',
    );

    state = {
      'isDarkMode': isDarkMode,
      'isNotificationsEnabled': isNotificationsEnabled,
      DateTime.now().toIso8601String(): DateTime.now().toIso8601String(),
    };
  }

  void toggleDarkMode() async {
    final currentDarkMode = state['isDarkMode'] as bool;
    await localStorageService.save(
      'isDarkMode',
      (!currentDarkMode).toString(),
    );
    state = {
      ...state,
      'isDarkMode': !currentDarkMode,
      DateTime.now().toIso8601String(): DateTime.now().toIso8601String(),
    };
  }

  void toggleNotifications() async {
    final currentNotificationsEnabled = state['isNotificationsEnabled'] as bool;
    await localStorageService.save(
      'isNotificationsEnabled',
      (!currentNotificationsEnabled).toString(),
    );
    state = {
      ...state,
      'isNotificationsEnabled': !currentNotificationsEnabled,
      DateTime.now().toIso8601String(): DateTime.now().toIso8601String(),
    };
  }
}

final settingsStateNotifierProvider =
    StateNotifierProvider<SettingsStateNotifier, Map<String, dynamic>>(
  (ref) => SettingsStateNotifier(
    ref.read(localStorageProvider),
  ),
);
