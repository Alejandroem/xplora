// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestImpl _$$QuestImplFromJson(Map<String, dynamic> json) => _$QuestImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      questId: json['questId'] as String?,
      category: json['category'] as String?,
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      imageUrl: json['imageUrl'] as String,
      experience: (json['experience'] as num).toDouble(),
      stepType: $enumDecode(_$QuestTypeEnumMap, json['stepType']),
      timeInSeconds: (json['timeInSeconds'] as num?)?.toInt(),
      stepLatitude: (json['stepLatitude'] as num?)?.toDouble(),
      stepLongitude: (json['stepLongitude'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toInt(),
      stepCode: json['stepCode'] as String?,
      hasNotified: json['hasNotified'] as bool?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      hoursToCompleteAgain: (json['hoursToCompleteAgain'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuestImplToJson(_$QuestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'questId': instance.questId,
      'category': instance.category,
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'imageUrl': instance.imageUrl,
      'experience': instance.experience,
      'stepType': _$QuestTypeEnumMap[instance.stepType]!,
      'timeInSeconds': instance.timeInSeconds,
      'stepLatitude': instance.stepLatitude,
      'stepLongitude': instance.stepLongitude,
      'distance': instance.distance,
      'stepCode': instance.stepCode,
      'hasNotified': instance.hasNotified,
      'completedAt': instance.completedAt?.toIso8601String(),
      'hoursToCompleteAgain': instance.hoursToCompleteAgain,
    };

const _$QuestTypeEnumMap = {
  QuestType.location: 'location',
  QuestType.timeLocation: 'timeLocation',
  QuestType.qr: 'qr',
};
