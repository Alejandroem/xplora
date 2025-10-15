import 'dart:developer';

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
        final now = DateTime.now().toUtc().toIso8601String();
        final xploraProfile = XploraProfile(
          id: user.id,
          userId: user.id!,
          experience: 0,
          categories: [],
          avatarUrl: '',
          username: '', // Will be set later in complete profile
          preferredLanguage: '',
          country: '',
          city: '',
          birthdayMonth: '',
          birthdayYear: '',
          gender: '',
          primaryInterestCategory: '',
          createdAt: now,
          updatedAt: now,
        );
        await profileService.create(xploraProfile);
      }
      // Note: Profile will be updated when user completes their profile

      // Fetch user settings after successful login
      await _fetchUserSettings(user.id!);
    } catch (e) {
      log(e.toString());
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
    state = state.copyWith(isLoading: false);
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
        log('No settings found for user $userId, creating default settings');
        await _createDefaultSettings(userId);
      } else {
        log('Fetched ${settings.length} settings for user $userId');
      }
    } catch (e) {
      log('Error fetching user settings: $e');
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
      
      log('Created default settings for user $userId');
    } catch (e) {
      log('Error creating default settings: $e');
    }
  }
}
