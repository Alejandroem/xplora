// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceImpl _$$PlaceImplFromJson(Map<String, dynamic> json) => _$PlaceImpl(
      placeId: json['placeId'] as String?,
      name: json['name'] as String,
      geo: (json['geo'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      geohash: json['geohash'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      address: json['address'] as String?,
      location: json['location'] as String?,
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
      'geohash': instance.geohash,
      'categories': instance.categories,
      'imageUrls': instance.imageUrls,
      'address': instance.address,
      'location': instance.location,
      'source': instance.source,
      'status': instance.status,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
