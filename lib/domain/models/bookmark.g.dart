// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookmarkImpl _$$BookmarkImplFromJson(Map<String, dynamic> json) =>
    _$BookmarkImpl(
      id: json['id'] as String?,
      entityId: json['entityId'] as String,
      type: $enumDecode(_$BookmarkTypeEnumMap, json['type']),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$BookmarkImplToJson(_$BookmarkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'entityId': instance.entityId,
      'type': _$BookmarkTypeEnumMap[instance.type]!,
      'userId': instance.userId,
    };

const _$BookmarkTypeEnumMap = {
  BookmarkType.quest: 'quest',
  BookmarkType.adventure: 'adventure',
};
