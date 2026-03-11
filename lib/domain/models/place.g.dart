// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategorySelectionImpl _$$CategorySelectionImplFromJson(
        Map<String, dynamic> json) =>
    _$CategorySelectionImpl(
      selectedId: json['selectedId'] as String,
      path:
          (json['path'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$CategorySelectionImplToJson(
        _$CategorySelectionImpl instance) =>
    <String, dynamic>{
      'selectedId': instance.selectedId,
      'path': instance.path,
    };

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      geo: json['geo'] as Map<String, dynamic>,
      categorySelections: (json['categorySelections'] as List<dynamic>?)
              ?.map(
                  (e) => CategorySelection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      location: json['location'] as String?,
      description: json['description'] as String?,
      validationConfigId: json['validationConfigId'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      contributionXp: (json['contributionXp'] as num?)?.toInt() ?? 0,
      userId: json['userId'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      source: json['source'] as String? ?? 'seed',
      status: json['status'] as String? ?? 'active',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$PlaceImplToJson(_$PlaceImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'geo': instance.geo,
      'categorySelections': instance.categorySelections,
      'imageUrls': instance.imageUrls,
      'location': instance.location,
      'description': instance.description,
      'validationConfigId': instance.validationConfigId,
      'xp': instance.xp,
      'contributionXp': instance.contributionXp,
      'userId': instance.userId,
      'rejectionReason': instance.rejectionReason,
      'source': instance.source,
      'status': instance.status,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
