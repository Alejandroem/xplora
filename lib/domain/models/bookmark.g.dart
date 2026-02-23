// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookmarkImpl _$$BookmarkImplFromJson(Map<String, dynamic> json) =>
    _$BookmarkImpl(
      id: json['id'] as String,
      type: $enumDecode(_$BookmarkTypeEnumMap, json['type']),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$BookmarkImplToJson(_$BookmarkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$BookmarkTypeEnumMap[instance.type]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };

const _$BookmarkTypeEnumMap = {
  BookmarkType.quest: 'quest',
  BookmarkType.place: 'place',
};
