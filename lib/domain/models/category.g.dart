// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryImpl _$$CategoryImplFromJson(Map<String, dynamic> json) =>
    _$CategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? '',
      interestName: json['interestName'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isVisibleInInterests: json['isVisibleInInterests'] as bool? ?? false,
      interestsOrder: (json['interestsOrder'] as num?)?.toInt() ?? 0,
      placeOrder: (json['placeOrder'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 0,
      parentId: json['parentId'] as String?,
      ancestorIds: (json['ancestorIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$CategoryImplToJson(_$CategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'interestName': instance.interestName,
      'isActive': instance.isActive,
      'isVisibleInInterests': instance.isVisibleInInterests,
      'interestsOrder': instance.interestsOrder,
      'placeOrder': instance.placeOrder,
      'level': instance.level,
      'parentId': instance.parentId,
      'ancestorIds': instance.ancestorIds,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
