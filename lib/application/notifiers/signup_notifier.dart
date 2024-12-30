import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/signup_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';

class SignupFormNotifier extends StateNotifier<SignupForm> {
  AuthService authenticationService;
  XploraProfileService profileService;
  SignupFormNotifier(
      super.state, this.authenticationService, this.profileService);

  void setUsername(String username) {
    if (username.isEmpty) {
      state = state
          .copyWith(username: username, touchedUsername: false, errors: []);
      return;
    }

    if (username.length < 6) {
      state = state.copyWith(
          username: username,
          touchedUsername: true,
          errors: ['Username must be at least 6 characters']);
      return;
    }

    state =
        state.copyWith(username: username, touchedUsername: true, errors: []);
  }

  void setEmail(String email) {
    if (email.isEmpty) {
      state = state.copyWith(email: email, touchedEmail: false, errors: []);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      state = state.copyWith(
          email: email, touchedEmail: true, errors: ['Invalid email']);
      return;
    }

    state = state.copyWith(email: email, touchedEmail: true, errors: []);
  }

  void setPassword(String password) {
    if (password.isEmpty) {
      state = state
          .copyWith(password: password, touchedPassword: false, errors: []);
      return;
    }

    if (password.length < 6) {
      state = state.copyWith(
          password: password,
          touchedPassword: true,
          errors: ['Password must be at least 6 characters']);
      return;
    }

    state =
        state.copyWith(password: password, touchedPassword: true, errors: []);
  }

  void setConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      state = state.copyWith(
          confirmPassword: confirmPassword,
          touchedConfirmPassword: false,
          errors: []);
      return;
    }

    if (confirmPassword != state.password) {
      state = state.copyWith(
          confirmPassword: confirmPassword,
          touchedConfirmPassword: true,
          errors: ['Passwords do not match']);
      return;
    }

    state = state.copyWith(
        confirmPassword: confirmPassword,
        touchedConfirmPassword: true,
        errors: []);
  }

  void setFirstName(String firstName) {
    if (firstName.isEmpty) {
      state = state
          .copyWith(firstName: firstName, touchedFirstName: false, errors: []);
      return;
    }

    state = state
        .copyWith(firstName: firstName, touchedFirstName: true, errors: []);
  }

  void setLastName(String lastName) {
    if (lastName.isEmpty) {
      state = state
          .copyWith(lastName: lastName, touchedLastName: false, errors: []);
      return;
    }

    state =
        state.copyWith(lastName: lastName, touchedLastName: true, errors: []);
  }

  bool isValid() {
    if (state.email.isEmpty) {
      state = state.copyWith(touchedEmail: true, errors: ['Email is required']);
      return false;
    }

    if (state.password.isEmpty) {
      state = state
          .copyWith(touchedPassword: true, errors: ['Password is required']);
      return false;
    }

    if (state.confirmPassword.isEmpty) {
      state = state.copyWith(
          touchedConfirmPassword: true,
          errors: ['Confirm password is required']);
      return false;
    }

    if (state.firstName.isEmpty) {
      state = state
          .copyWith(touchedFirstName: true, errors: ['First name is required']);
      return false;
    }

    if (state.lastName.isEmpty) {
      state = state
          .copyWith(touchedLastName: true, errors: ['Last name is required']);
      return false;
    }

    state = state.copyWith(errors: []);
    return true;
  }

  Future<void> signUp() async {
    state = state.copyWith(isLoading: true);
    isValid();
    if (state.errors.isNotEmpty) {
      return;
    }

    try {
      final user = await authenticationService.signUpWithEmailAndPassword(
        state.email,
        state.password,
        '${state.firstName} ${state.lastName}',
        state.username,
      );

      final profiles = await profileService.readBy('userId', user.id!);
      if (profiles.isEmpty) {
        //Create empty profile
        final xploraProfile = XploraProfile(
          id: null,
          userId: user.id!,
          experience: 0,
          categories: [],
          avatarUrl: '',
          username: '',
        );
        await profileService.create(xploraProfile);
      }
    } catch (e) {
      state = state.copyWith(errors: [e.toString()]);
    }
    state = state.copyWith(isLoading: false);
  }
}
