import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/complete_profile_form.dart';
import '../notifiers/complete_profile_notifier.dart';
import 'profile_providers.dart';
import 'auth_service_providers.dart';
import 'storage_providers.dart';

final completeProfileFormNotifierProvider = StateNotifierProvider<CompleteProfileFormNotifier, CompleteProfileForm>((ref) {
  final profileService = ref.watch(profileServiceProvider);
  final authService = ref.watch(authServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return CompleteProfileFormNotifier(
    const CompleteProfileForm(
      username: '',
      touchedUsername: false,
      avatarUrl: '',
      preferredLanguage: '',
      touchedPreferredLanguage: false,
      country: '',
      touchedCountry: false,
      city: '',
      touchedCity: false,
      birthdayMonth: '',
      touchedBirthdayMonth: false,
      birthdayYear: '',
      touchedBirthdayYear: false,
      gender: '',
      touchedGender: false,
      primaryInterestCategory: '',
      touchedPrimaryInterestCategory: false,
      errors: [],
      isLoading: false,
      isUsernameUnique: false,
      isCheckingUsername: false,
      countries: [],
      cities: [],
      isLoadingCountries: false,
    ),
    profileService,
    authService,
    storageService,
  );
});
