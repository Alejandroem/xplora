// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complete_profile_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompleteProfileFormImpl _$$CompleteProfileFormImplFromJson(
        Map<String, dynamic> json) =>
    _$CompleteProfileFormImpl(
      displayName: json['displayName'] as String,
      touchedDisplayName: json['touchedDisplayName'] as bool,
      username: json['username'] as String,
      touchedUsername: json['touchedUsername'] as bool,
      avatarUrl: json['avatarUrl'] as String,
      preferredLanguage: json['preferredLanguage'] as String,
      touchedPreferredLanguage: json['touchedPreferredLanguage'] as bool,
      country: json['country'] as String,
      touchedCountry: json['touchedCountry'] as bool,
      city: json['city'] as String,
      touchedCity: json['touchedCity'] as bool,
      birthdayMonth: json['birthdayMonth'] as String,
      touchedBirthdayMonth: json['touchedBirthdayMonth'] as bool,
      birthdayYear: json['birthdayYear'] as String,
      touchedBirthdayYear: json['touchedBirthdayYear'] as bool,
      gender: json['gender'] as String,
      touchedGender: json['touchedGender'] as bool,
      primaryInterestCategory: json['primaryInterestCategory'] as String,
      touchedPrimaryInterestCategory:
          json['touchedPrimaryInterestCategory'] as bool,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      isLoading: json['isLoading'] as bool,
      isUsernameUnique: json['isUsernameUnique'] as bool,
      countries: (json['countries'] as List<dynamic>)
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList(),
      cities: (json['cities'] as List<dynamic>)
          .map((e) => City.fromJson(e as Map<String, dynamic>))
          .toList(),
      isLoadingCountries: json['isLoadingCountries'] as bool,
    );

Map<String, dynamic> _$$CompleteProfileFormImplToJson(
        _$CompleteProfileFormImpl instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'touchedDisplayName': instance.touchedDisplayName,
      'username': instance.username,
      'touchedUsername': instance.touchedUsername,
      'avatarUrl': instance.avatarUrl,
      'preferredLanguage': instance.preferredLanguage,
      'touchedPreferredLanguage': instance.touchedPreferredLanguage,
      'country': instance.country,
      'touchedCountry': instance.touchedCountry,
      'city': instance.city,
      'touchedCity': instance.touchedCity,
      'birthdayMonth': instance.birthdayMonth,
      'touchedBirthdayMonth': instance.touchedBirthdayMonth,
      'birthdayYear': instance.birthdayYear,
      'touchedBirthdayYear': instance.touchedBirthdayYear,
      'gender': instance.gender,
      'touchedGender': instance.touchedGender,
      'primaryInterestCategory': instance.primaryInterestCategory,
      'touchedPrimaryInterestCategory': instance.touchedPrimaryInterestCategory,
      'errors': instance.errors,
      'isLoading': instance.isLoading,
      'isUsernameUnique': instance.isUsernameUnique,
      'countries': instance.countries,
      'cities': instance.cities,
      'isLoadingCountries': instance.isLoadingCountries,
    };
