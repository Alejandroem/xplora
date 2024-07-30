import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/notifiers/login_notifier.dart';
import '../../application/notifiers/signup_notifier.dart';
import '../../domain/models/login_form.dart';
import '../../domain/models/signup_form.dart';
import '../../domain/services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import 'xplorauser_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final profileStreamProvider = StreamProvider.autoDispose((ref) async* {
  final authService = ref.watch(authServiceProvider);
  final user = await authService.getAuthUser();
  final profileService = ref.watch(profileServiceProvider);
  if (user == null) {
    yield null;
  } else {
    yield* profileService.getStream(user.id!);
  }
});

final loginFormNotifierProvider =
    StateNotifierProvider<LoginFormNotifier, LoginForm>((ref) {
  final authService = ref.watch(authServiceProvider);
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
      authService);
});

final signupFormNotifierProvider =
    StateNotifierProvider<SignupFormNotifier, SignupForm>((ref) {
  final authService = ref.watch(authServiceProvider);
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
  );
});
