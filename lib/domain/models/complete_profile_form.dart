import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/services/country_city_data_service.dart';

part 'complete_profile_form.freezed.dart';
part 'complete_profile_form.g.dart';

@freezed
abstract class CompleteProfileForm with _$CompleteProfileForm {
  const factory CompleteProfileForm({
    required String username,
    required bool touchedUsername,
    required String avatarUrl,
    required String preferredLanguage,
    required bool touchedPreferredLanguage,
    required String country,
    required bool touchedCountry,
    required String city,
    required bool touchedCity,
    required String birthdayMonth,
    required bool touchedBirthdayMonth,
    required String birthdayYear,
    required bool touchedBirthdayYear,
    required String gender,
    required bool touchedGender,
    required String primaryInterestCategory,
    required bool touchedPrimaryInterestCategory,
    required List<String> errors,
    required bool isLoading,
    required bool isUsernameUnique,
    required bool isCheckingUsername,
    required List<Country> countries,
    required List<City> cities,
    required bool isLoadingCountries,
    required bool isLoadingCities,
  }) = _CompleteProfileForm;

  factory CompleteProfileForm.fromJson(Map<String, dynamic> json) =>
      _$CompleteProfileFormFromJson(json);
}
