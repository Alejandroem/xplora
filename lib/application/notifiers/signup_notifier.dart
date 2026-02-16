import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/signup_form.dart';
import '../../domain/models/xplora_profile.dart';
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

  void setDisplayName(String displayName) {
    if (displayName.isEmpty) {
      state = state.copyWith(
          displayName: displayName, touchedDisplayName: false, errors: []);
      return;
    }

    if (RegExp(r'[0-9]').hasMatch(displayName)) {
      state = state.copyWith(
          displayName: displayName,
          touchedDisplayName: true,
          errors: ['Name cannot contain numbers']);
      return;
    }

    state = state.copyWith(
        displayName: displayName, touchedDisplayName: true, errors: []);
  }


  bool isValid() {
    if (state.displayName.isEmpty) {
      state = state.copyWith(touchedDisplayName: true, errors: ['Name is required']);
      return false;
    }

    if (RegExp(r'[0-9]').hasMatch(state.displayName)) {
      state = state.copyWith(touchedDisplayName: true, errors: ['Name cannot contain numbers']);
      return false;
    }

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

    // Track if user account was created for rollback purposes
    bool userCreated = false;

    try {
      // Step 1: Create Firebase Auth account
      final user = await authenticationService.signUpWithEmailAndPassword(
        state.email,
        state.password,
        state.displayName,
      );
      userCreated = true;

      // Step 2: Create profile for new user (profile cannot exist for newly created user)
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

      // Step 3: Create default settings for the new user (critical for app to function)
      await _createDefaultSettings(user.id!);

      // Success - all steps completed
      state = state.copyWith(isLoading: false);

    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException during signup: $e');
      // Firebase Auth errors happen before user is created, no rollback needed
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
      state = state.copyWith(isLoading: false);

    } on TimeoutException catch (e) {
      print('TimeoutException during signup: $e');

      // Rollback: If user was created but subsequent steps timed out, logout
      if (userCreated) {
        await _rollbackSignup('Signup timed out after account creation');
      }

      state = state.copyWith(
        errors: ['Sign up timed out. Please check your connection and try again.'],
        isLoading: false,
      );

    } catch (e) {
      print('Unexpected error during signup: $e');

      // Rollback: If user was created but profile/settings creation failed, logout
      if (userCreated) {
        await _rollbackSignup('Signup failed after account creation: $e');
      }

      state = state.copyWith(
        errors: ['An error occurred during signup. Please try again.'],
        isLoading: false,
      );
    }
  }


  /// Rollback signup by logging out user if profile or settings creation fails
  /// This ensures user doesn't get stuck with incomplete data
  /// Next login attempt will trigger _ensureSettingsExist in LoginNotifier
  Future<void> _rollbackSignup(String reason) async {
    try {
      print('Rolling back signup: $reason');
      await authenticationService.signOut();
      print('User logged out successfully after signup failure');
    } catch (logoutError) {
      print('Error during rollback logout: $logoutError');
      // If logout fails, user might be stuck - but this is extremely rare
      // They can still manually logout or login will handle missing data
    }
  }

  /// Creates default settings for a new user
  /// Throws exception on failure to trigger rollback
  Future<void> _createDefaultSettings(String userId) async {
    // Check actual permission status for notifications and location
    final notificationStatus = await Permission.notification.status;
    final locationStatus = await Permission.location.status;

    // Create default settings using service
    // Don't catch errors - let them bubble up to trigger rollback
    await settingsService.createDefaultSettings(
      userId: userId,
      locationEnabled: locationStatus.isGranted,
      notificationsEnabled: notificationStatus.isGranted,
      darkModeEnabled: true, // Dark mode enabled by default
    );

    print('Default settings created successfully for user $userId');
  }

}
