// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignupFormImpl _$$SignupFormImplFromJson(Map<String, dynamic> json) =>
    _$SignupFormImpl(
      username: json['username'] as String,
      touchedUsername: json['touchedUsername'] as bool,
      email: json['email'] as String,
      touchedEmail: json['touchedEmail'] as bool,
      password: json['password'] as String,
      touchedPassword: json['touchedPassword'] as bool,
      confirmPassword: json['confirmPassword'] as String,
      touchedConfirmPassword: json['touchedConfirmPassword'] as bool,
      firstName: json['firstName'] as String,
      touchedFirstName: json['touchedFirstName'] as bool,
      lastName: json['lastName'] as String,
      touchedLastName: json['touchedLastName'] as bool,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      isLoading: json['isLoading'] as bool,
    );

Map<String, dynamic> _$$SignupFormImplToJson(_$SignupFormImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'touchedUsername': instance.touchedUsername,
      'email': instance.email,
      'touchedEmail': instance.touchedEmail,
      'password': instance.password,
      'touchedPassword': instance.touchedPassword,
      'confirmPassword': instance.confirmPassword,
      'touchedConfirmPassword': instance.touchedConfirmPassword,
      'firstName': instance.firstName,
      'touchedFirstName': instance.touchedFirstName,
      'lastName': instance.lastName,
      'touchedLastName': instance.touchedLastName,
      'errors': instance.errors,
      'isLoading': instance.isLoading,
    };
