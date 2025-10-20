import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/xp_onboarding_form.dart';
import '../../domain/services/auth_service.dart';
import '../../application/providers/settings_providers.dart';

class XpOnboardingNotifier extends StateNotifier<XpOnboardingForm> {
  final AuthService authService;
  final Ref ref;

  XpOnboardingNotifier(
    super.state,
    this.authService,
    this.ref,
  );

  void setBio(String bio) {
    if (bio.isEmpty) {
      state = state.copyWith(bio: bio, touchedBio: false, errors: []);
      return;
    }

    if (bio.length > 500) {
      state = state.copyWith(
        bio: bio,
        touchedBio: true,
        errors: ['Bio must be 500 characters or less'],
      );
      return;
    }

    state = state.copyWith(bio: bio, touchedBio: true, errors: []);
  }

  void setInstagramHandle(String handle) {
    state = state.copyWith(
      instagramHandle: handle,
      touchedInstagram: true,
      errors: [],
    );
  }

  void setTwitterHandle(String handle) {
    state = state.copyWith(
      twitterHandle: handle,
      touchedTwitter: true,
      errors: [],
    );
  }

  void setFacebookHandle(String handle) {
    state = state.copyWith(
      facebookHandle: handle,
      touchedFacebook: true,
      errors: [],
    );
  }

  Future<void> enableNotifications() async {
    state = state.copyWith(isEnablingNotifications: true, errors: []);

    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
              settings.authorizationStatus == AuthorizationStatus.provisional;

      if (isGranted) {
        // Save to settings
        final settingsNotifier =
            ref.read(settingsStateNotifierProvider.notifier);
        await settingsNotifier.setNotificationsEnabled(true);

        state = state.copyWith(
          notificationsEnabled: true,
          isEnablingNotifications: false,
        );
      } else {
        state = state.copyWith(
          isEnablingNotifications: false,
          errors: ['Notification permission was denied'],
        );
      }
    } catch (e) {
      state = state.copyWith(
        errors: ['Failed to enable notifications: ${e.toString()}'],
        isEnablingNotifications: false,
      );
    }
  }

  void markReferralCompleted() {
    state = state.copyWith(referralCompleted: true);
  }

  bool _validateForm() {
    final errors = <String>[];

    // Bio is optional but if provided, must be <= 500 chars
    if (state.bio.isNotEmpty && state.bio.length > 500) {
      errors.add('Bio must be 500 characters or less');
    }

    state = state.copyWith(errors: errors);
    return errors.isEmpty;
  }

  Future<void> saveProfile() async {
    if (!_validateForm()) {
      return;
    }

    state = state.copyWith(isLoading: true, isSaving: true);

    try {
      final user = await authService.getAuthUser();
      if (user == null) {
        state = state.copyWith(
          errors: ['User not authenticated'],
          isLoading: false,
          isSaving: false,
        );
        return;
      }

      final userId = user.id;

      // Prepare data to save
      final Map<String, dynamic> profileData = {};

      if (state.bio.isNotEmpty) {
        profileData['bio'] = state.bio;
      }

      // Social links
      final Map<String, String> socialLinks = {};
      if (state.instagramHandle.isNotEmpty) {
        socialLinks['instagram'] = state.instagramHandle;
      }
      if (state.twitterHandle.isNotEmpty) {
        socialLinks['twitter'] = state.twitterHandle;
      }
      if (state.facebookHandle.isNotEmpty) {
        socialLinks['facebook'] = state.facebookHandle;
      }

      if (socialLinks.isNotEmpty) {
        profileData['socialLinks'] = socialLinks;
      }

      // Save to Firestore
      if (profileData.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('profile')
            .doc('data')
            .update(profileData);
      }

      state = state.copyWith(isLoading: false, isSaving: false, errors: []);
    } catch (e) {
      state = state.copyWith(
        errors: ['Failed to save profile: ${e.toString()}'],
        isLoading: false,
        isSaving: false,
      );
    }
  }
}
