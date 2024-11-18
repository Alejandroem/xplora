// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xplora_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$XploraProfileImpl _$$XploraProfileImplFromJson(Map<String, dynamic> json) =>
    _$XploraProfileImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      level: (json['level'] as num).toInt(),
      experience: (json['experience'] as num).toInt(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      avatarUrl: json['avatarUrl'] as String?,
      username: json['username'] as String?,
    );

Map<String, dynamic> _$$XploraProfileImplToJson(_$XploraProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'level': instance.level,
      'experience': instance.experience,
      'categories': instance.categories,
      'avatarUrl': instance.avatarUrl,
      'username': instance.username,
    };
