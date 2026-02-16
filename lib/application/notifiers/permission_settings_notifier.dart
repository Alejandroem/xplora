import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Permission settings state
class PermissionSettings {
  final bool locationAccess;
  final bool cameraAccess;
  final bool motionActivity;
  final bool backgroundRefresh;
  final bool notifications;

  const PermissionSettings({
    this.locationAccess = true,
    this.cameraAccess = true,
    this.motionActivity = true,
    this.backgroundRefresh = true,
    this.notifications = true,
  });

  PermissionSettings copyWith({
    bool? locationAccess,
    bool? cameraAccess,
    bool? motionActivity,
    bool? backgroundRefresh,
    bool? notifications,
  }) {
    return PermissionSettings(
      locationAccess: locationAccess ?? this.locationAccess,
      cameraAccess: cameraAccess ?? this.cameraAccess,
      motionActivity: motionActivity ?? this.motionActivity,
      backgroundRefresh: backgroundRefresh ?? this.backgroundRefresh,
      notifications: notifications ?? this.notifications,
    );
  }
}

/// Permission settings notifier
class PermissionSettingsNotifier extends StateNotifier<PermissionSettings> {
  PermissionSettingsNotifier() : super(const PermissionSettings());

  void toggleLocationAccess(bool value) {
    state = state.copyWith(locationAccess: value);
    // TODO: Save to storage/database
    // TODO: Request/revoke actual system permission
  }

  void toggleCameraAccess(bool value) {
    state = state.copyWith(cameraAccess: value);
    // TODO: Save to storage/database
    // TODO: Request/revoke actual system permission
  }

  void toggleMotionActivity(bool value) {
    state = state.copyWith(motionActivity: value);
    // TODO: Save to storage/database
    // TODO: Request/revoke actual system permission
  }

  void toggleBackgroundRefresh(bool value) {
    state = state.copyWith(backgroundRefresh: value);
    // TODO: Save to storage/database
    // TODO: Request/revoke actual system permission
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notifications: value);
    // TODO: Save to storage/database
    // TODO: Request/revoke actual system permission
  }
}

/// Provider for permission settings
final permissionSettingsProvider =
    StateNotifierProvider<PermissionSettingsNotifier, PermissionSettings>(
  (ref) => PermissionSettingsNotifier(),
);
