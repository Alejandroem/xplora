import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/login_notifier.dart';
import '../notifiers/signup_notifier.dart';
import '../../domain/models/login_form.dart';
import '../../domain/models/signup_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/auth_service.dart';
import '../../infrastructure/services/firebase_auth_service.dart';
import 'xplorauser_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final isAuthenticatedProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);

  return authService.isSignedIn;
});

final currentAuthUserIdStreamProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.getAuthUserStreamUserId();
});

final createOrReadCurrentUserProfile = FutureProvider.autoDispose((ref) async {
  final profileService = ref.read(profileServiceProvider);
  final authenticationService = ref.read(authServiceProvider);
  final user = await authenticationService.getAuthUser();
  if (user == null) {
    return null;
  }

  final profile = await profileService.readBy('userId', user.id!);
  if (profile.isEmpty) {
    return await profileService.create(
      XploraProfile(
        id: null,
        userId: user.id!,
        level: 0,
        experience: 0,
        categories: [],
        avatarUrl: '',
        username: '',
      ),
    );
  } else {
    return profile.first;
  }
});

//provides an instance of XploraProfile based on the auth user
final createOrReadProfileStreamProvider = StreamProvider.autoDispose((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  return authService.getAuthUserStreamUserId().asyncMap((userId) {
    if (userId != null) {
      return profileService.streamByFilters(
        [
          {
            'field': 'id',
            'operator': '==',
            'value': userId,
          }
        ],
      );
    }
    return null;
  });
});

final loginFormNotifierProvider =
    StateNotifierProvider<LoginFormNotifier, LoginForm>((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
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
  );
});

final signupFormNotifierProvider =
    StateNotifierProvider<SignupFormNotifier, SignupForm>((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  return SignupFormNotifier(
    const SignupForm(
      username: '',
      touchedUsername: false,
      email: '',
      touchedEmail: false,
      password: '',
      touchedPassword: false,
      errors: [],
      confirmPassword: '',
      touchedConfirmPassword: false,
      firstName: '',
      touchedFirstName: false,
      lastName: '',
      touchedLastName: false,
      isLoading: false,
    ),
    authService,
    profileService,
  );
});
