// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestStepImpl _$$QuestStepImplFromJson(Map<String, dynamic> json) =>
    _$QuestStepImpl(
      id: json['id'] as String?,
      questId: json['questId'] as String,
      stepName: json['stepName'] as String,
      stepDescription: json['stepDescription'] as String,
      stepCode: json['stepCode'] as String,
      stepLatitude: (json['stepLatitude'] as num).toDouble(),
      stepLongitude: (json['stepLongitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$QuestStepImplToJson(_$QuestStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questId': instance.questId,
      'stepName': instance.stepName,
      'stepDescription': instance.stepDescription,
      'stepCode': instance.stepCode,
      'stepLatitude': instance.stepLatitude,
      'stepLongitude': instance.stepLongitude,
    };
