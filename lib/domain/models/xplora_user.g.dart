// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xplora_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$XploraUserImpl _$$XploraUserImplFromJson(Map<String, dynamic> json) =>
    _$XploraUserImpl(
      id: json['id'] as String?,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      username: json['username'] as String,
      isEmailVerified: json['isEmailVerified'] as bool,
    );

Map<String, dynamic> _$$XploraUserImplToJson(_$XploraUserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'displayName': instance.displayName,
      'username': instance.username,
      'isEmailVerified': instance.isEmailVerified,
    };
