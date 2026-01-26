import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accessibility settings state
/// Only includes settings with switches shown on the main accessibility page
class AccessibilitySettings {
  final bool simplifiedMode;
  final bool appSounds;
  final bool voiceAssistance;

  const AccessibilitySettings({
    this.simplifiedMode = false,
    this.appSounds = false,
    this.voiceAssistance = false,
  });

  AccessibilitySettings copyWith({
    bool? simplifiedMode,
    bool? appSounds,
    bool? voiceAssistance,
  }) {
    return AccessibilitySettings(
      simplifiedMode: simplifiedMode ?? this.simplifiedMode,
      appSounds: appSounds ?? this.appSounds,
      voiceAssistance: voiceAssistance ?? this.voiceAssistance,
    );
  }
}

/// Accessibility settings notifier
class AccessibilitySettingsNotifier extends StateNotifier<AccessibilitySettings> {
  AccessibilitySettingsNotifier() : super(const AccessibilitySettings());

  void toggleSimplifiedMode(bool value) {
    state = state.copyWith(simplifiedMode: value);
    // TODO: Save to storage/database
  }

  void toggleAppSounds(bool value) {
    state = state.copyWith(appSounds: value);
    // TODO: Save to storage/database
  }

  void toggleVoiceAssistance(bool value) {
    state = state.copyWith(voiceAssistance: value);
    // TODO: Save to storage/database
  }
}

/// Provider for accessibility settings
final accessibilitySettingsProvider =
    StateNotifierProvider<AccessibilitySettingsNotifier, AccessibilitySettings>(
  (ref) => AccessibilitySettingsNotifier(),
);
