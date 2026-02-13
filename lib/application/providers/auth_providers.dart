import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/login_notifier.dart';
import '../notifiers/signup_notifier.dart';
import '../../domain/models/login_form.dart';
import '../../domain/models/signup_form.dart';
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

final createOrReadCurrentUserProfile = StreamProvider.autoDispose((ref) {
  final profileService = ref.watch(profileServiceProvider);
  final authenticationService = ref.watch(authServiceProvider);

  // Initialize lastUserId from current auth state (ref.listen doesn't fire on initial value)
  final initialAuthUserId = ref.read(currentAuthUserIdStreamProvider).value;
  String? lastUserId = initialAuthUserId;

  // Listen to auth changes and invalidate when user switches
  ref.listen(currentAuthUserIdStreamProvider, (previous, next) {
    final newUserId = next.value;

    // Detect user switch: new user signs in after a different user
    if (newUserId != null && lastUserId != null && lastUserId != newUserId) {
      // User switched - invalidate to get fresh stream for new user
      ref.invalidateSelf();
      return;
    }

    // Track last non-null user
    if (newUserId != null) {
      lastUserId = newUserId;
    }
  });

  // Keep alive during tab switches to prevent reload
  Timer? keepAliveTimer;

  ref.onCancel(() {
    final link = ref.keepAlive();

    // Auto-dispose after 60 seconds of inactivity
    keepAliveTimer = Timer(const Duration(seconds: 60), () {
      link.close();
    });
  });

  ref.onResume(() {
    keepAliveTimer?.cancel();
  });

  ref.onDispose(() {
    keepAliveTimer?.cancel();
  });

  // Use asyncExpand to automatically switch streams when auth state changes
  // This cancels the old profile stream and starts listening to the new user's profile
  return authenticationService.getAuthUserStream().asyncExpand((user) {
    if (user == null) {
      // User signed out - emit null
      return Stream.value(null);
    }

    // User signed in - listen to their profile stream (real-time updates)
    // When profile is created/updated, it will automatically emit here
    return profileService.getStream(user.id!);
  });
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
