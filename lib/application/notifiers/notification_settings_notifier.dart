import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification settings state
class NotificationSettings {
  final bool allowNotifications;
  final bool questUpdates;
  final bool xpProgress;
  final bool streakReminders;
  final bool nearbyActivityAlerts;
  final bool socialInteractions;
  final bool appUpdatesNews;

  const NotificationSettings({
    this.allowNotifications = true,
    this.questUpdates = false,
    this.xpProgress = true,
    this.streakReminders = false,
    this.nearbyActivityAlerts = false,
    this.socialInteractions = false,
    this.appUpdatesNews = true,
  });

  NotificationSettings copyWith({
    bool? allowNotifications,
    bool? questUpdates,
    bool? xpProgress,
    bool? streakReminders,
    bool? nearbyActivityAlerts,
    bool? socialInteractions,
    bool? appUpdatesNews,
  }) {
    return NotificationSettings(
      allowNotifications: allowNotifications ?? this.allowNotifications,
      questUpdates: questUpdates ?? this.questUpdates,
      xpProgress: xpProgress ?? this.xpProgress,
      streakReminders: streakReminders ?? this.streakReminders,
      nearbyActivityAlerts: nearbyActivityAlerts ?? this.nearbyActivityAlerts,
      socialInteractions: socialInteractions ?? this.socialInteractions,
      appUpdatesNews: appUpdatesNews ?? this.appUpdatesNews,
    );
  }
}

/// Notification settings notifier
class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings());

  void toggleAllowNotifications(bool value) {
    state = state.copyWith(allowNotifications: value);
    // TODO: Save to storage/database
  }

  void toggleQuestUpdates(bool value) {
    state = state.copyWith(questUpdates: value);
    // TODO: Save to storage/database
  }

  void toggleXpProgress(bool value) {
    state = state.copyWith(xpProgress: value);
    // TODO: Save to storage/database
  }

  void toggleStreakReminders(bool value) {
    state = state.copyWith(streakReminders: value);
    // TODO: Save to storage/database
  }

  void toggleNearbyActivityAlerts(bool value) {
    state = state.copyWith(nearbyActivityAlerts: value);
    // TODO: Save to storage/database
  }

  void toggleSocialInteractions(bool value) {
    state = state.copyWith(socialInteractions: value);
    // TODO: Save to storage/database
  }

  void toggleAppUpdatesNews(bool value) {
    state = state.copyWith(appUpdatesNews: value);
    // TODO: Save to storage/database
  }
}

/// Provider for notification settings
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);
