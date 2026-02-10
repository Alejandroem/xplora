import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/login_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/models/setting.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/settings_crud_service.dart';

class LoginFormNotifier extends StateNotifier<LoginForm> {
  AuthService authenticationService;
  XploraProfileService profileService;
  SettingsCrudService settingsService;
  LoginFormNotifier(
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

  void toggleObscureText() {
    state = state.copyWith(obscureText: !state.obscureText);
  }

  bool isValid() {
    final errors = <String>[];
    if (state.email.isEmpty) {
      errors.add('Email is required');
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email)) {
      errors.add('Please enter a valid email');
    }
    if (state.password.isEmpty) {
      errors.add('Password is required');
    } else if (state.password.length < 6) {
      errors.add('Password must be at least 6 characters');
    }
    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  Future<void> login() async {
    state = state.copyWith(isLoading: true);
    final valid = isValid();
    if (!valid) {
      state = state.copyWith(isLoading: false);
    }
    if (state.errors.isNotEmpty) return;
    try {
      final user = await authenticationService.signInWithEmailAndPassword(
        state.email,
        state.password,
      );

      final profiles = await profileService.readBy('userId', user.id!);
      if (profiles.isEmpty) {
        //Create profile with username from authenticated user
        final now = Timestamp.now();
        final xploraProfile = XploraProfile(
          id: user.id,
          userId: user.id!,
          experience: 0,
          interests: [],
          avatarUrl: '',
          bio: '',
          createdAt: now,
          updatedAt: now,
        );
        await profileService.create(xploraProfile);
      }
      // Note: Profile will be updated when user completes their profile

      // Fetch user settings after successful login
      await _fetchUserSettings(user.id!);
    } catch (e) {
      print(e.toString());
      String errorMessage = 'Error logging in, please try again.';
      
      // Parse Firebase Auth specific errors
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No account found with this email address.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'The email address is not valid.';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'This account has been disabled.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many failed attempts. Please try again later.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = 'Invalid email or password.';
      }
      
      state = state.copyWith(
        errors: [errorMessage],
        isLoading: false,
      );
      throw Exception(errorMessage);
    }
    // state = state.copyWith(isLoading: false);
  }

  /// Google Sign-In with proper error handling
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errors: []);

    try {
      // Sign in with Google (Google SDK handles its own timeouts)
      // Returns the user, whether this is a new Firebase Auth user, and the Google photo URL
      final result = await authenticationService.signInWithGoogle();
      final user = result.user;
      final isNewUser = result.isNewUser;
      final photoUrl = result.photoUrl;

      print('user: ${user.id}');
      print('isNewUser (from Firebase): $isNewUser');
      print('Google photo URL: $photoUrl');

      if (isNewUser) {
        // New user - create profile and follow signup flow
        print('New Google user detected, creating profile');
        final now = Timestamp.now();
        final xploraProfile = XploraProfile(
          id: user.id,
          userId: user.id!,
          experience: 0,
          interests: [],
          avatarUrl: photoUrl ?? '', // Save Google photo URL if available
          bio: '',
          createdAt: now,
          updatedAt: now,
        );
        await profileService.create(xploraProfile);

        // Create default settings for new user
        await _createDefaultSettings(user.id!);
      } else {
        // Existing user - just fetch their settings
        print('Existing Google user detected, fetching settings');
        await _fetchUserSettings(user.id!);
      }

      // Keep isLoading: true on success - the UI will navigate away and the login notifier will be auto disposed
      // Setting it to false would briefly show "Sign in" button before navigation
      state = state.copyWith(
        needsProfileCompletion: isNewUser,
      );

    } on UnimplementedError catch (e) {
      print('Google sign-in not implemented: ${e.message}');
      state = state.copyWith(
        errors: ['Google Sign-In is not yet available. Please use email and password.'],
        isLoading: false,
      );
    } catch (e) {
      print('Google sign-in error: ${e.toString()}');

      // If user canceled the sign-in, don't show any error message
      if (e.toString().contains('sign_in_canceled')) {
        print('User canceled Google sign-in');
        state = state.copyWith(isLoading: false);
        return;
      }

      // For all other errors, show appropriate error messages
      String errorMessage = 'Error signing in with Google. Please try again.';

      if (e.toString().contains('sign_in_failed')) {
        errorMessage = 'Google sign-in failed. Please try again.';
      } else if (e.toString().contains('network_error') || e.toString().contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.toString().contains('account-exists-with-different-credential')) {
        errorMessage = 'An account already exists with this email using a different sign-in method.';
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = 'Invalid Google credentials. Please try again.';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'This Google account has been disabled.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many sign-in attempts. Please try again later.';
      }

      state = state.copyWith(
        errors: [errorMessage],
        isLoading: false,
      );
    }
  }

  /// Fetches user settings after successful login
  Future<void> _fetchUserSettings(String userId) async {
    try {
      final settings = await settingsService.readByFilters([
        {
          'field': 'userId',
          'operator': '==',
          'value': userId,
        }
      ]);
      
      // If user has no settings, create default ones
      if (settings == null || settings.isEmpty) {
        print('No settings found for user $userId, creating default settings');
        await _createDefaultSettings(userId);
      } else {
        print('Fetched ${settings.length} settings for user $userId');
      }
    } catch (e) {
      print('Error fetching user settings: $e');
    }
  }

  /// Creates default settings for a user (same as signup)
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
      
      print('Created default settings for user $userId');
    } catch (e) {
      print('Error creating default settings: $e');
    }
  }
}
