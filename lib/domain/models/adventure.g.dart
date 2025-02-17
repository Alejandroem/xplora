// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdventureImpl _$$AdventureImplFromJson(Map<String, dynamic> json) =>
    _$AdventureImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      adventureId: json['adventureId'] as String?,
      category: json['category'] as String?,
      featured: json['featured'] as bool?,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      imageUrl: json['imageUrl'] as String,
      featuredImages: (json['featuredImages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      experience: (json['experience'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: (json['distance'] as num?)?.toInt(),
      hasNotified: json['hasNotified'] as bool?,
      timeInSeconds: (json['timeInSeconds'] as num?)?.toInt(),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      hoursToCompleteAgain: (json['hoursToCompleteAgain'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AdventureImplToJson(_$AdventureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'adventureId': instance.adventureId,
      'category': instance.category,
      'featured': instance.featured,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'imageUrl': instance.imageUrl,
      'featuredImages': instance.featuredImages,
      'experience': instance.experience,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'distance': instance.distance,
      'hasNotified': instance.hasNotified,
      'timeInSeconds': instance.timeInSeconds,
      'completedAt': instance.completedAt?.toIso8601String(),
      'hoursToCompleteAgain': instance.hoursToCompleteAgain,
    };
