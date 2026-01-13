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
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      avatarUrl: json['avatarUrl'] as String?,
      username: json['username'] as String?,
      bio: json['bio'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      birthdayMonth: json['birthdayMonth'] as String?,
      birthdayYear: json['birthdayYear'] as String?,
      gender: json['gender'] as String?,
      primaryInterestCategory: json['primaryInterestCategory'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$$XploraProfileImplToJson(_$XploraProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'experience': instance.experience,
      'categories': instance.categories,
      'avatarUrl': instance.avatarUrl,
      'username': instance.username,
      'bio': instance.bio,
      'preferredLanguage': instance.preferredLanguage,
      'country': instance.country,
      'city': instance.city,
      'birthdayMonth': instance.birthdayMonth,
      'birthdayYear': instance.birthdayYear,
      'gender': instance.gender,
      'primaryInterestCategory': instance.primaryInterestCategory,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
