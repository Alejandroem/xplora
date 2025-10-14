import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/complete_profile_form.dart';
import '../../domain/services/xplora_profile_service.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/country_city_data_service.dart';

class CompleteProfileFormNotifier extends StateNotifier<CompleteProfileForm> {
  XploraProfileService profileService;
  AuthService authService;
  
  CompleteProfileFormNotifier(super.state, this.profileService, this.authService);

  void setDisplayName(String displayName) {
    if (displayName.isEmpty) {
      state = state
          .copyWith(displayName: displayName, touchedDisplayName: false, errors: []);
      return;
    }

    if (RegExp(r'[0-9]').hasMatch(displayName)) {
      state = state.copyWith(
          displayName: displayName,
          touchedDisplayName: true,
          errors: ['Display name cannot contain numbers']);
      return;
    }

    state = state
        .copyWith(displayName: displayName, touchedDisplayName: true, errors: []);
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
    try {
      final cities = await CountryCityDataService.getCitiesForCountry(countryName);
      state = state.copyWith(cities: cities);
    } catch (e) {
      state = state.copyWith(
        cities: [],
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
    );
    
    // Add a small delay to prevent dropdown from closing immediately
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Load cities for the selected country
    await loadCitiesForCountry(countryName);
  }

  bool isValid() {
    if (state.displayName.isEmpty) {
      state = state.copyWith(touchedDisplayName: true, errors: ['Display name is required']);
      return false;
    }

    if (RegExp(r'[0-9]').hasMatch(state.displayName)) {
      state = state.copyWith(touchedDisplayName: true, errors: ['Display name cannot contain numbers']);
      return false;
    }

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

    if (state.city.isEmpty) {
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

    state = state.copyWith(errors: []);
    return true;
  }

  Future<void> completeProfile() async {
    state = state.copyWith(isLoading: true);
    final valid = isValid();
    if (!valid) {
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

      final profiles = await profileService.readBy('userId', currentUser.id!);
      if (profiles.isNotEmpty) {
        final profile = profiles.first;
        final updatedProfile = profile.copyWith(
          username: state.username,
          avatarUrl: state.avatarUrl,
          // Add other fields as needed when XploraProfile model is updated
        );
        await profileService.update(updatedProfile, profile.id!);
      }
    } catch (e) {
      state = state.copyWith(errors: [e.toString()]);
    }
    state = state.copyWith(isLoading: false);
  }
}
