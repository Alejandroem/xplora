import 'package:freezed_annotation/freezed_annotation.dart';

part 'xp_onboarding_form.freezed.dart';

@freezed
class XpOnboardingForm with _$XpOnboardingForm {
  const factory XpOnboardingForm({
    required String bio,
    required bool touchedBio,
    required String instagramHandle,
    required bool touchedInstagram,
    required String twitterHandle,
    required bool touchedTwitter,
    required String facebookHandle,
    required bool touchedFacebook,
    required bool notificationsEnabled,
    required bool referralCompleted,
    required List<String> errors,
    required bool isLoading,
    required bool isSaving,
    required bool isEnablingNotifications,
  }) = _XpOnboardingForm;
}
