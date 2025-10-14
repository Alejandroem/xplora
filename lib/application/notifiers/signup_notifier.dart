import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/signup_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/models/setting.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/settings_crud_service.dart';

class SignupFormNotifier extends StateNotifier<SignupForm> {
  AuthService authenticationService;
  XploraProfileService profileService;
  SettingsCrudService settingsService;
  SignupFormNotifier(
      super.state, this.authenticationService, this.profileService, this.settingsService);


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


  bool isValid() {
    if (state.email.isEmpty) {
      state = state.copyWith(touchedEmail: true, errors: ['Email is required']);
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      state = state.copyWith(touchedEmail: true, errors: ['Please enter a valid email address']);
      return false;
    }

    if (state.password.isEmpty) {
      state = state
          .copyWith(touchedPassword: true, errors: ['Password is required']);
      return false;
    }

    if (state.password.length < 6) {
      state = state.copyWith(
          touchedPassword: true,
          errors: ['Password must be at least 6 characters']);
      return false;
    }

    if (state.confirmPassword.isEmpty) {
      state = state.copyWith(
          touchedConfirmPassword: true,
          errors: ['Confirm password is required']);
      return false;
    }

    if (state.confirmPassword != state.password) {
      state = state.copyWith(
          touchedConfirmPassword: true,
          errors: ['Passwords do not match']);
      return false;
    }

    state = state.copyWith(errors: []);
    return true;
  }

  Future<void> signUp() async {
    state = state.copyWith(isLoading: true);
    final valid = isValid();
    if (!valid) {
      state = state.copyWith(isLoading: false);
    }
    if (state.errors.isNotEmpty) {
      return;
    }

    try {
      final user = await authenticationService.signUpWithEmailAndPassword(
        state.email,
        state.password,
        '', // Empty display name for now, will be set in profile completion
        '', // Empty username for now, will be set in profile completion
      );

      final profiles = await profileService.readBy('userId', user.id!);
      if (profiles.isEmpty) {
        //Create profile with empty username for now
        final xploraProfile = XploraProfile(
          id: null,
          userId: user.id!,
          experience: 0,
          categories: [],
          avatarUrl: '',
          username: '', // Empty username for now, will be set in profile completion
        );
        await profileService.create(xploraProfile);
      }

      // Create default settings for the new user
      await _createDefaultSettings(user.id!);
      
      // Fetch user settings to ensure they're available
      await _fetchUserSettings(user.id!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        state = state.copyWith(errors: ['Email already in use, please use a different email']);
      } else if (e.code == 'weak-password') {
        state = state.copyWith(errors: ['Password is too weak, please use a stronger password']);
      } else if (e.code == 'invalid-email') {
        state = state.copyWith(errors: ['Invalid email, please use a valid email']);
      } else if (e.code == 'network-request-failed') {
        state = state.copyWith(errors: ['Network error, please check your connection and try again']);
      } else {
        state = state.copyWith(errors: ['An error occurred, please try again: $e']);
      }
    } catch (e) {
      state = state.copyWith(errors: ['An error occurred, please try again']);
    }
    state = state.copyWith(isLoading: false);
  }


  /// Creates default settings for a new user
  Future<void> _createDefaultSettings(String userId) async {
    try {
      final now = DateTime.now();
      
      // Check actual permission status for notifications and location
      final notificationStatus = await Permission.notification.status;
      final locationStatus = await Permission.location.status;
      
      // Create default settings based on actual permissions
      final defaultSettings = [
        Setting(
          id: null,
          userId: userId,
          key: 'isDarkMode',
          value: true, // Dark mode enabled by default
          variableType: 'bool',
          updatedAt: now,
        ),
        Setting(
          id: null,
          userId: userId,
          key: 'isNotificationsEnabled',
          value: notificationStatus.isGranted, // Based on actual permission
          variableType: 'bool',
          updatedAt: now,
        ),
        Setting(
          id: null,
          userId: userId,
          key: 'isLocationEnabled',
          value: locationStatus.isGranted, // Based on actual permission
          variableType: 'bool',
          updatedAt: now,
        ),
      ];

      // Create all default settings
      for (final setting in defaultSettings) {
        await settingsService.create(setting);
      }
    } catch (e) {
      // Log error but don't fail signup for settings creation
      print('Error creating default settings: $e');
    }
  }

  /// Fetches user settings after successful signup
  Future<void> _fetchUserSettings(String userId) async {
    try {
      final settings = await settingsService.readByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': userId,
        }
      ]);
      
      // Settings are now available in the settings provider
      // The SettingsStateNotifier will automatically pick them up
      print('Fetched ${settings?.length ?? 0} settings for user $userId');
    } catch (e) {
      print('Error fetching user settings: $e');
    }
  }
}
