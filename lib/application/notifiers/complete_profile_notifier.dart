import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/complete_profile_form.dart';
import '../../domain/models/xplora_profile.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/storage_service.dart';
import '../../domain/services/country_city_data_service.dart';

class CompleteProfileFormNotifier extends StateNotifier<CompleteProfileForm> {
  XploraProfileService profileService;
  AuthService authService;
  StorageService storageService;
  Timer? _usernameValidationTimer;
  
  CompleteProfileFormNotifier(super.state, this.profileService, this.authService, this.storageService);

  @override
  void dispose() {
    _usernameValidationTimer?.cancel();
    super.dispose();
  }

  /// Load existing profile data (e.g., Google photo URL) when initializing the page
  Future<void> loadExistingProfile() async {
    try {
      final currentUser = await authService.getAuthUser();
      if (currentUser == null) return;

      final profiles = await profileService.readBy('userId', currentUser.id!);
      if (profiles.isNotEmpty) {
        final profile = profiles.first;
        // Pre-populate avatar URL if it exists (e.g., from Google Sign-In)
        if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty) {
          state = state.copyWith(avatarUrl: profile.avatarUrl!);
        }
      }
    } catch (e) {
      print('Error loading existing profile: $e');
    }
  }

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

  void setAvatarUrl(String avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }

  void setPreferredLanguage(String language) {
    state = state.copyWith(
        preferredLanguage: language, 
        touchedPreferredLanguage: true, 
        errors: []);
  }

  void setCountry(String country) {
    state = state.copyWith(
        country: country, 
        touchedCountry: true, 
        errors: []);
  }

  void setCity(String city) {
    state = state.copyWith(
        city: city, 
        touchedCity: true, 
        errors: []);
  }

  void setBirthdayMonth(String month) {
    state = state.copyWith(
        birthdayMonth: month, 
        touchedBirthdayMonth: true, 
        errors: []);
  }

  void setBirthdayYear(String year) {
    state = state.copyWith(
        birthdayYear: year, 
        touchedBirthdayYear: true, 
        errors: []);
  }

  void setGender(String gender) {
    state = state.copyWith(
        gender: gender, 
        touchedGender: true, 
        errors: []);
  }

  void setPrimaryInterestCategory(String category) {
    state = state.copyWith(
        primaryInterestCategory: category, 
        touchedPrimaryInterestCategory: true, 
        errors: []);
  }

  void setUsernameUnique(bool isUnique) {
    state = state.copyWith(isUsernameUnique: isUnique);
  }

  Future<void> checkUsernameAvailability(String username) async {
    // Cancel previous timer
    _usernameValidationTimer?.cancel();
    
    if (username.isEmpty || username.length < 6) {
      state = state.copyWith(isUsernameUnique: false, isCheckingUsername: false);
      return;
    }

    // Set loading state immediately
    state = state.copyWith(isCheckingUsername: true);

    // Debounce the validation by 500ms
    _usernameValidationTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performUsernameValidation(username);
    });
  }

  Future<void> _performUsernameValidation(String username) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      
      final isAvailable = querySnapshot.docs.isEmpty;
      state = state.copyWith(isUsernameUnique: isAvailable, isCheckingUsername: false);
    } catch (e) {
      state = state.copyWith(isUsernameUnique: false, isCheckingUsername: false);
    }
  }

  Future<void> loadCountries() async {
    state = state.copyWith(isLoadingCountries: true);
    try {
      final countries = await CountryCityDataService.getCountries();
      state = state.copyWith(
        countries: countries,
        isLoadingCountries: false,
      );
    } catch (e) {
      state = state.copyWith(
        errors: ['Error loading countries: $e'],
        isLoadingCountries: false,
      );
    }
  }

  Future<void> loadCitiesForCountry(String countryName) async {
    state = state.copyWith(isLoadingCities: true);
    try {
      final cities = await CountryCityDataService.getCitiesForCountry(countryName);
      state = state.copyWith(
        cities: cities,
        isLoadingCities: false,
      );
    } catch (e) {
      state = state.copyWith(
        cities: [],
        isLoadingCities: false,
        errors: ['Error loading cities: $e'],
      );
    }
  }

  void clearCities() {
    state = state.copyWith(cities: []);
  }

  Future<void> selectCountry(String countryName) async {
    // Update country and clear city in a single state update
    state = state.copyWith(
      country: countryName,
      city: '',
      cities: [],
      touchedCountry: true,
      errors: [],
    );

    // Load cities for the selected country
    await loadCitiesForCountry(countryName);
  }

  bool isValid() {
    if (state.username.isEmpty) {
      state = state.copyWith(touchedUsername: true, errors: ['Username is required']);
      return false;
    }

    if (state.username.length < 6) {
      state = state.copyWith(touchedUsername: true, errors: ['Username must be at least 6 characters']);
      return false;
    }

    if (state.preferredLanguage.isEmpty) {
      state = state.copyWith(touchedPreferredLanguage: true, errors: ['Preferred language is required']);
      return false;
    }

    if (state.country.isEmpty) {
      state = state.copyWith(touchedCountry: true, errors: ['Country is required']);
      return false;
    }

    if (state.cities.isNotEmpty && state.city.isEmpty) {
      state = state.copyWith(touchedCity: true, errors: ['City is required']);
      return false;
    }

    if (state.birthdayMonth.isEmpty) {
      state = state.copyWith(touchedBirthdayMonth: true, errors: ['Birthday month is required']);
      return false;
    }

    if (state.birthdayYear.isEmpty) {
      state = state.copyWith(touchedBirthdayYear: true, errors: ['Birthday year is required']);
      return false;
    }

    if (state.primaryInterestCategory.isEmpty) {
      state = state.copyWith(touchedPrimaryInterestCategory: true, errors: ['Primary interest category is required']);
      return false;
    }

    if (!state.isUsernameUnique) {
      state = state.copyWith(touchedUsername: true, errors: ['Username is already taken']);
      return false;
    }

    state = state.copyWith(errors: []);
    return true;
  }

  Future<void> completeProfile() async {
    state = state.copyWith(isLoading: true);
    
    // Wait for any pending username validation to complete
    // if (state.username.isNotEmpty && state.username.length >= 6) {
    //   await _performUsernameValidation(state.username);
    // }
    
    final valid = isValid();
    if (!valid) {
      state = state.copyWith(isLoading: false);
      return;
    }

    if(state.errors.isNotEmpty) {
      state = state.copyWith(isLoading: false);
      return;
    }

    try {
      // Get current user's profile
      final currentUser = await authService.getAuthUser();
      if (currentUser == null) {
        state = state.copyWith(errors: ['User not authenticated']);
        state = state.copyWith(isLoading: false);
        return;
      }

      // Update username in user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id!)
          .update({'username': state.username});

      // Upload avatar image to Firebase Storage if it's a local file path
      String avatarUrl = state.avatarUrl;
      if (state.avatarUrl.isNotEmpty && !state.avatarUrl.startsWith('http')) {
        try {
          avatarUrl = await storageService.uploadImage(
            state.avatarUrl, 
            currentUser.id!
          );
        } catch (e) {
          state = state.copyWith(errors: ['Failed to upload profile image: $e']);
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      // Create or update the complete XploraProfile with all data
      final now = DateTime.now().toUtc().toIso8601String();
      final completeProfile = XploraProfile(
        id: currentUser.id,
        userId: currentUser.id!,
        experience: 0, // Default experience
        categories: [], // Default empty categories
        avatarUrl: avatarUrl,
        username: state.username,
        bio: '',
        preferredLanguage: state.preferredLanguage,
        country: state.country,
        city: state.city,
        birthdayMonth: state.birthdayMonth,
        birthdayYear: state.birthdayYear,
        gender: state.gender,
        primaryInterestCategory: state.primaryInterestCategory,
        createdAt: now,
        updatedAt: now,
      );

      // Save to user subcollection: users/{userId}/profile/data
      await profileService.updateOrCreate(completeProfile, currentUser.id!);
    } catch (e) {
      state = state.copyWith(errors: [e.toString()]);
    }
    state = state.copyWith(isLoading: false);
  }
}
