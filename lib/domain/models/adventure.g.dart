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
      featured: json['featured'] as bool?,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      imageUrl: json['imageUrl'] as String,
      experience: (json['experience'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$AdventureImplToJson(_$AdventureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'adventureId': instance.adventureId,
      'featured': instance.featured,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'imageUrl': instance.imageUrl,
      'experience': instance.experience,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
