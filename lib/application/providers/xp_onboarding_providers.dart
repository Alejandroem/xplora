import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/xp_onboarding_form.dart';
import '../notifiers/xp_onboarding_notifier.dart';
import 'auth_service_providers.dart';

final xpOnboardingFormNotifierProvider =
    StateNotifierProvider<XpOnboardingNotifier, XpOnboardingForm>((ref) {
  final authService = ref.watch(authServiceProvider);
  return XpOnboardingNotifier(
    const XpOnboardingForm(
      bio: '',
      touchedBio: false,
      instagramHandle: '',
      touchedInstagram: false,
      twitterHandle: '',
      touchedTwitter: false,
      facebookHandle: '',
      touchedFacebook: false,
      notificationsEnabled: false,
      referralCompleted: false,
      errors: [],
      isLoading: false,
      isSaving: false,
      isEnablingNotifications: false,
    ),
    authService,
    ref,
  );
});
