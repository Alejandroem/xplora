import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Privacy settings state
class PrivacySettings {
  final bool publicProfile;
  final bool searchVisibility;
  final bool showOnlineStatus;
  final bool locationUsage;
  final bool analyticsAndCrashReports;

  const PrivacySettings({
    this.publicProfile = true,
    this.searchVisibility = false,
    this.showOnlineStatus = false,
    this.locationUsage = true,
    this.analyticsAndCrashReports = true,
  });

  PrivacySettings copyWith({
    bool? publicProfile,
    bool? searchVisibility,
    bool? showOnlineStatus,
    bool? locationUsage,
    bool? analyticsAndCrashReports,
  }) {
    return PrivacySettings(
      publicProfile: publicProfile ?? this.publicProfile,
      searchVisibility: searchVisibility ?? this.searchVisibility,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      locationUsage: locationUsage ?? this.locationUsage,
      analyticsAndCrashReports: analyticsAndCrashReports ?? this.analyticsAndCrashReports,
    );
  }
}

/// Privacy settings notifier
class PrivacySettingsNotifier extends StateNotifier<PrivacySettings> {
  PrivacySettingsNotifier() : super(const PrivacySettings());

  void togglePublicProfile(bool value) {
    state = state.copyWith(publicProfile: value);
    // TODO: Save to storage/database
  }

  void toggleSearchVisibility(bool value) {
    state = state.copyWith(searchVisibility: value);
    // TODO: Save to storage/database
  }

  void toggleShowOnlineStatus(bool value) {
    state = state.copyWith(showOnlineStatus: value);
    // TODO: Save to storage/database
  }

  void toggleLocationUsage(bool value) {
    state = state.copyWith(locationUsage: value);
    // TODO: Save to storage/database
  }

  void toggleAnalyticsAndCrashReports(bool value) {
    state = state.copyWith(analyticsAndCrashReports: value);
    // TODO: Save to storage/database
  }
}

/// Provider for privacy settings
final privacySettingsProvider =
    StateNotifierProvider<PrivacySettingsNotifier, PrivacySettings>(
  (ref) => PrivacySettingsNotifier(),
);
