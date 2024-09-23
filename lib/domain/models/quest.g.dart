// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestImpl _$$QuestImplFromJson(Map<String, dynamic> json) => _$QuestImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      questId: json['questId'] as String?,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      imageUrl: json['imageUrl'] as String,
      experience: (json['experience'] as num).toDouble(),
      stepType: $enumDecode(_$QuestTypeEnumMap, json['stepType']),
      timeInSeconds: (json['timeInSeconds'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      stepCode: json['stepCode'] as String?,
    );

Map<String, dynamic> _$$QuestImplToJson(_$QuestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'questId': instance.questId,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'imageUrl': instance.imageUrl,
      'experience': instance.experience,
      'stepType': _$QuestTypeEnumMap[instance.stepType]!,
      'timeInSeconds': instance.timeInSeconds,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'stepCode': instance.stepCode,
    };

const _$QuestTypeEnumMap = {
  QuestType.location: 'location',
  QuestType.timeLocation: 'timeLocation',
  QuestType.qr: 'qr',
};
