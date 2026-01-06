import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/login_notifier.dart';
import '../notifiers/signup_notifier.dart';
import '../../domain/models/login_form.dart';
import '../../domain/models/signup_form.dart';
import '../../domain/models/xplora_profile.dart';
import 'xplorauser_providers.dart';
import 'settings_crud_providers.dart';
import 'auth_service_providers.dart';


final isAuthenticatedProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.isSignedIn;
});

final currentAuthUserIdStreamProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getAuthUserStreamUserId();
});

final currentAuthUserStreamProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getAuthUserStream();
});

final currentUserProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getAuthUserStream();
});

final createOrReadCurrentUserProfile = StreamProvider((ref) async* {
  final profileService = ref.read(profileServiceProvider);
  final authenticationService = ref.read(authServiceProvider);
  final user = await authenticationService.getAuthUser();
  if (user == null) {
    yield null;
    return;
  }

  // First check if profile exists
  final existingProfile = await profileService.read(user.id!);

  // Create profile if it doesn't exist
  if (existingProfile == null) {
    await profileService.create(
      XploraProfile(
        id: null,
        userId: user.id!,
        experience: 0,
        categories: [],
        avatarUrl: '',
        username: '',
        preferredLanguage: '',
        country: '',
        city: '',
        birthdayMonth: '',
        birthdayYear: '',
        gender: '',
        primaryInterestCategory: '',
        createdAt: '',
        updatedAt: '',
      ),
    );
  }

  // Now stream the profile
  await for (final profile in profileService.getStream(user.id!)) {
    yield profile;
  }
});

/// Provider that formats user location from profile as "City, State/Country"
/// Returns null if user has no city/country set or is not authenticated
final userLocationStringProvider = StreamProvider<String?>((ref) async* {
  await for (final profile in ref.watch(createOrReadCurrentUserProfile.stream)) {
    if (profile == null) {
      yield null;
      continue;
    }

    final city = profile.city;
    final country = profile.country;

    // Only return location if both city and country/state are available
    if (city != null && city.isNotEmpty &&
        country != null && country.isNotEmpty) {
      yield '$city, $country';
    } else {
      yield null;
    }
  }
});

//provides an instance of XploraProfile based on the auth user
final createOrReadProfileStreamProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  return authService.getAuthUserStreamUserId().asyncMap((userId) {
    if (userId != null) {
      return profileService.getStream(userId);
    }
    return null;
  });
});

final loginFormNotifierProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginForm>((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  final settingsService = ref.watch(settingsCrudServiceProvider);
  return LoginFormNotifier(
    const LoginForm(
      email: '',
      touchedEmail: false,
      password: '',
      touchedPassword: false,
      obscureText: true,
      errors: [],
      isLoading: false,
    ),
    authService,
    profileService,
    settingsService,
  );
});

final signupFormNotifierProvider =
    StateNotifierProvider<SignupFormNotifier, SignupForm>((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  final settingsService = ref.watch(settingsCrudServiceProvider);
  return SignupFormNotifier(
    const SignupForm(
      email: '',
      touchedEmail: false,
      password: '',
      touchedPassword: false,
      errors: [],
      confirmPassword: '',
      touchedConfirmPassword: false,
      displayName: '',
      touchedDisplayName: false,
      isLoading: false,
    ),
    authService,
    profileService,
    settingsService,
  );
});
