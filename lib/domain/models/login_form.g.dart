// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginFormImpl _$$LoginFormImplFromJson(Map<String, dynamic> json) =>
    _$LoginFormImpl(
      email: json['email'] as String,
      touchedEmail: json['touchedEmail'] as bool,
      password: json['password'] as String,
      touchedPassword: json['touchedPassword'] as bool,
      obscureText: json['obscureText'] as bool,
      errors:
          (json['errors'] as List<dynamic>).map((e) => e as String).toList(),
      isLoading: json['isLoading'] as bool,
    );

Map<String, dynamic> _$$LoginFormImplToJson(_$LoginFormImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'touchedEmail': instance.touchedEmail,
      'password': instance.password,
      'touchedPassword': instance.touchedPassword,
      'obscureText': instance.obscureText,
      'errors': instance.errors,
      'isLoading': instance.isLoading,
    };
