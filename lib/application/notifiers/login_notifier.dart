import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/login_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/xplora_user_crud_service.dart';
import '../../domain/services/settings_crud_service.dart';

class LoginFormNotifier extends StateNotifier<LoginForm> {
  AuthService authenticationService;
  XploraProfileService profileService;
  XploraUserService userService;
  SettingsCrudService settingsService;
  LoginFormNotifier(super.state, this.authenticationService,
      this.profileService, this.userService, this.settingsService);

  void setEmail(String email) {
    if (email.isEmpty) {
      state = state.copyWith(email: email, touchedEmail: false, errors: []);
      return;
    }

    // No email format validation - we accept username OR email
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
    // Accept username OR email - no format validation
    if (state.email.isEmpty) {
      errors.add('Email or Username is required');
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

    // Track if user signed in for rollback purposes
    bool userSignedIn = false;

    try {
      // Determine if input is email or username
      String emailToUse = state.email;
      final isEmailFormat =
          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(state.email);

      // If not email format, treat as username and fetch email
      if (!isEmailFormat) {
        print('Fetching email for username ${state.email}');
        final fetchedEmail = await userService.getEmailByUsername(state.email);

        if (fetchedEmail == null) {
          // Username not found
          state = state.copyWith(
            errors: ['Invalid email/username or password.'],
            isLoading: false,
          );
          return; // Return early instead of throwing
        }

        emailToUse = fetchedEmail;
      } else {
        print('Using email ${state.email}');
      }

      print('Logging in with email $emailToUse');

      // Step 1: Sign in with email (either provided or fetched from username)
      final user = await authenticationService.signInWithEmailAndPassword(
        emailToUse,
        state.password,
      );
      userSignedIn = true;

      // Step 2: Create profile if missing
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

      // Step 3: Ensure settings exist (create defaults if missing)
      // Settings will be fetched when UI invalidates the provider
      await _ensureSettingsExist(user.id!);

      // Success - all steps completed
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      // Firebase Auth errors happen before/during sign-in, no rollback needed
      String errorMessage = 'Error logging in, please try again.';

      // Parse Firebase Auth specific errors using error codes
      if (e.code == 'user-not-found') {
        errorMessage = 'No account found with this email address.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password. Please try again.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many failed attempts. Please try again later.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid email/username or password.';
      }

      state = state.copyWith(
        errors: [errorMessage],
        isLoading: false,
      );
      throw Exception(errorMessage);
    } on TimeoutException catch (e) {
      print('TimeoutException during login: $e');

      // Rollback: If user signed in but subsequent steps timed out, logout
      if (userSignedIn) {
        await _rollbackLogin('Login timed out after sign-in');
      }

      state = state.copyWith(
        errors: [
          'Sign in timed out. Please check your connection and try again.'
        ],
        isLoading: false,
      );
      throw Exception(
          'Sign in timed out. Please check your connection and try again.');
    } catch (e) {
      print('Unexpected error during login: $e');

      // Rollback: If user signed in but profile/settings creation failed, logout
      if (userSignedIn) {
        await _rollbackLogin('Login failed after sign-in: $e');
      }

      state = state.copyWith(
        errors: ['An unexpected error occurred. Please try again.'],
        isLoading: false,
      );
      throw Exception('An unexpected error occurred. Please try again.');
    }
  }

  /// Google Sign-In with proper error handling
  Future<void> loginWithGoogle() async {
    state = state.copyWith(isLoading: true, errors: []);

    // Track if user signed in for rollback purposes
    bool userSignedIn = false;

    try {
      // Step 1: Sign in with Google (Google SDK handles its own timeouts)
      // Returns the user, whether this is a new Firebase Auth user, and the Google photo URL
      final result = await authenticationService.signInWithGoogle();
      final user = result.user;
      final isNewUser = result.isNewUser;
      final photoUrl = result.photoUrl;
      userSignedIn = true;

      print('user: ${user.id}');
      print('isNewUser (from Firebase): $isNewUser');
      print('Google photo URL: $photoUrl');

      if (isNewUser) {
        // Step 2: New user - create profile and follow signup flow
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

        // Step 3: Create default settings for new user
        await _createDefaultSettings(user.id!);
      } else {
        // Existing user - ensure settings exist (create if missing)
        print('Existing Google user detected, ensuring settings exist');
        await _ensureSettingsExist(user.id!);
      }

      // Success - Keep isLoading: true on success
      // The UI will navigate away and the login notifier will be auto disposed
      // Setting it to false would briefly show "Sign in" button before navigation
      state = state.copyWith(
        needsProfileCompletion: isNewUser,
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      // Firebase Auth errors happen before/during sign-in, no rollback needed
      String errorMessage = 'Error signing in with Google. Please try again.';

      // Parse Firebase Auth specific errors using error codes
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with this email using a different sign-in method.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid Google credentials. Please try again.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This Google account has been disabled.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Google Sign-In is not enabled for this app.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your connection.';
      }

      state = state.copyWith(
        errors: [errorMessage],
        isLoading: false,
      );
    } on TimeoutException catch (e) {
      print('TimeoutException during Google sign-in: $e');

      // Rollback: If user signed in but subsequent steps timed out, logout
      if (userSignedIn) {
        await _rollbackLogin('Google sign-in timed out after authentication');
      }

      state = state.copyWith(
        errors: [
          'Google sign-in timed out. Please check your connection and try again.'
        ],
        isLoading: false,
      );
    } on UnimplementedError catch (e) {
      print('Google sign-in not implemented: ${e.message}');
      state = state.copyWith(
        errors: [
          'Google Sign-In is not yet available. Please use email and password.'
        ],
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

      // Rollback: If user signed in but profile/settings creation failed, logout
      if (userSignedIn) {
        await _rollbackLogin('Google sign-in failed after authentication: $e');
      }

      state = state.copyWith(
        errors: [
          'An unexpected error occurred during Google sign-in. Please try again.'
        ],
        isLoading: false,
      );
    }
  }

  /// Apple Sign-In with proper error handling and rollback
  Future<void> loginWithApple() async {
    state = state.copyWith(isLoading: true, errors: []);

    // Track if user signed in for rollback purposes
    bool userSignedIn = false;

    try {
      // Step 1: Sign in with Apple (Apple SDK handles its own flows)
      // Returns the user, whether this is a new Firebase Auth user, and photo URL
      final result = await authenticationService.signInWithApple();
      final user = result.user;
      final isNewUser = result.isNewUser;
      final photoUrl = result.photoUrl;
      userSignedIn = true;

      print('user: ${user.id}');
      print('isNewUser (from Firebase): $isNewUser');
      print('Apple photo URL: $photoUrl');

      if (isNewUser) {
        // Step 2: New user - create profile and follow signup flow
        print('New Apple user detected, creating profile');
        final now = Timestamp.now();
        final xploraProfile = XploraProfile(
          id: user.id,
          userId: user.id!,
          experience: 0,
          interests: [],
          avatarUrl: photoUrl ?? '', // Apple doesn't provide photos
          bio: '',
          createdAt: now,
          updatedAt: now,
        );
        await profileService.create(xploraProfile);

        // Step 3: Create default settings for new user
        await _createDefaultSettings(user.id!);
      } else {
        // Existing user - ensure settings exist (create if missing)
        print('Existing Apple user detected, ensuring settings exist');
        await _ensureSettingsExist(user.id!);
      }

      // Success - Keep isLoading: true on success
      // The UI will navigate away and the login notifier will be auto disposed
      // Setting it to false would briefly show "Sign in" button before navigation
      state = state.copyWith(
        needsProfileCompletion: isNewUser,
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: $e');
      // Firebase Auth errors happen before/during sign-in, no rollback needed
      String errorMessage = 'Error signing in with Apple. Please try again.';

      // Parse Firebase Auth specific errors using error codes
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage =
            'An account already exists with this email using a different sign-in method.';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Invalid Apple credentials. Please try again.';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'This Apple account has been disabled.';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Apple Sign-In is not enabled for this app.';
      } else if (e.code == 'network-request-failed') {
        errorMessage = 'Network error. Please check your connection.';
      }

      state = state.copyWith(
        errors: [errorMessage],
        isLoading: false,
      );
    } on TimeoutException catch (e) {
      print('TimeoutException during Apple sign-in: $e');

      // Rollback: If user signed in but subsequent steps timed out, logout
      if (userSignedIn) {
        await _rollbackLogin('Apple sign-in timed out after authentication');
      }

      state = state.copyWith(
        errors: [
          'Apple sign-in timed out. Please check your connection and try again.'
        ],
        isLoading: false,
      );
    } catch (e) {
      print('Apple sign-in error: ${e.toString()}');

      // If user canceled the sign-in, don't show any error message
      if (e.toString().contains('sign_in_canceled')) {
        print('User canceled Apple sign-in');
        state = state.copyWith(isLoading: false);
        return;
      }

      // Rollback: If user signed in but profile/settings creation failed, logout
      if (userSignedIn) {
        await _rollbackLogin('Apple sign-in failed after authentication: $e');
      }

      state = state.copyWith(
        errors: [
          'An unexpected error occurred during Apple sign-in. Please try again.'
        ],
        isLoading: false,
      );
    }
  }

  /// Ensures user settings exist (creates defaults if missing)
  /// Settings will be fetched when the settings provider is invalidated
  /// Throws exception on failure to trigger rollback
  Future<void> _ensureSettingsExist(String userId) async {
    final settings = await settingsService.readByFilters([
      {
        'field': 'userId',
        'operator': '==',
        'value': userId,
      }
    ]);

    // If user has no settings, create default ones (handles legacy users)
    if (settings == null || settings.isEmpty) {
      print('No settings found for user $userId, creating default settings');
      await _createDefaultSettings(userId);
    }
    // If settings exist, do nothing - let the provider fetch them
    // Don't catch errors - let them bubble up to trigger rollback
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

  /// Rollback login by logging out user if profile or settings creation fails
  /// This ensures user doesn't get stuck with incomplete data
  /// User can retry login to trigger data creation again
  Future<void> _rollbackLogin(String reason) async {
    try {
      print('Rolling back login: $reason');
      await authenticationService.signOut();
      print('User logged out successfully after login failure');
    } catch (logoutError) {
      print('Error during rollback logout: $logoutError');
      // If logout fails, user might be stuck - but this is extremely rare
      // They can still manually logout or retry login which will handle missing data
    }
  }
}
