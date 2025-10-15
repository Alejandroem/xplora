// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupFormImpl _$$SignupFormImplFromJson(Map<String, dynamic> json) =>
    _$SignupFormImpl(
      email: json['email'] as String,
      touchedEmail: json['touchedEmail'] as bool,
      password: json['password'] as String,
      touchedPassword: json['touchedPassword'] as bool,
      confirmPassword: json['confirmPassword'] as String,
      touchedConfirmPassword: json['touchedConfirmPassword'] as bool,
      displayName: json['displayName'] as String,
      touchedDisplayName: json['touchedDisplayName'] as bool,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      isLoading: json['isLoading'] as bool,
    );

Map<String, dynamic> _$$SignupFormImplToJson(_$SignupFormImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'touchedEmail': instance.touchedEmail,
      'password': instance.password,
      'touchedPassword': instance.touchedPassword,
      'confirmPassword': instance.confirmPassword,
      'touchedConfirmPassword': instance.touchedConfirmPassword,
      'displayName': instance.displayName,
      'touchedDisplayName': instance.touchedDisplayName,
      'errors': instance.errors,
      'isLoading': instance.isLoading,
    };
