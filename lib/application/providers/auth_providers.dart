import 'package:cloud_firestore/cloud_firestore.dart';
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

final createOrReadCurrentUserProfile = StreamProvider.autoDispose((ref) async* {
  final profileService = ref.watch(profileServiceProvider);
  final authenticationService = ref.watch(authServiceProvider);

  // Keep the provider alive to prevent disposal during tab switches
  ref.keepAlive();

  // Listen to the auth user stream to react to login/logout events
  await for (final user in authenticationService.getAuthUserStream()) {
    if (user == null) {
      yield null;
      continue;
    }

    // First check if profile exists
    // final existingProfile = await profileService.read(user.id!);
    //
    // // Create profile if it doesn't exist
    // if (existingProfile == null) {
    //   final now = Timestamp.now();
    //   await profileService.create(
    //     XploraProfile(
    //       id: null,
    //       userId: user.id!,
    //       experience: 0,
    //       interests: [],
    //       avatarUrl: '',
    //       bio: '',
    //       createdAt: now,
    //       updatedAt: now,
    //     ),
    //   );
    // }

    // Yield the current profile (read it fresh after potential creation)
    final profile = await profileService.read(user.id!);
    yield profile;
  }
});

/// Provider that formats user location from profile as "City, State/Country"
/// Returns null since city/country fields have been removed from profile
final userLocationStringProvider =
    Provider.autoDispose<AsyncValue<String?>>((ref) {
  // City and country fields removed from XploraProfile
  // Always return null - location features will be added back when needed
  return const AsyncValue.data(null);
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
  final userService = ref.watch(userServiceProvider);
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
    userService,
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
