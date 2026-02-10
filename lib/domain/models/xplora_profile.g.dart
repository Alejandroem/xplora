// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xplora_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$XploraProfileImpl _$$XploraProfileImplFromJson(Map<String, dynamic> json) =>
    _$XploraProfileImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      experience: (json['experience'] as num).toInt(),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$XploraProfileImplToJson(_$XploraProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'experience': instance.experience,
      'interests': instance.interests,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
