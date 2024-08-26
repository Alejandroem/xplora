// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestStepImpl _$$QuestStepImplFromJson(Map<String, dynamic> json) =>
    _$QuestStepImpl(
      id: json['id'] as String?,
      questId: json['questId'] as String?,
      completed: json['completed'] as bool?,
      stepName: json['stepName'] as String,
      stepDescription: json['stepDescription'] as String,
      stepType: $enumDecode(_$StepTypeEnumMap, json['stepType']),
      stepLatitude: (json['stepLatitude'] as num?)?.toDouble(),
      stepLongitude: (json['stepLongitude'] as num?)?.toDouble(),
      stepCode: json['stepCode'] as String?,
      stepTime: (json['stepTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuestStepImplToJson(_$QuestStepImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questId': instance.questId,
      'completed': instance.completed,
      'stepName': instance.stepName,
      'stepDescription': instance.stepDescription,
      'stepType': _$StepTypeEnumMap[instance.stepType]!,
      'stepLatitude': instance.stepLatitude,
      'stepLongitude': instance.stepLongitude,
      'stepCode': instance.stepCode,
      'stepTime': instance.stepTime,
    };

const _$StepTypeEnumMap = {
  StepType.location: 'location',
  StepType.timeLocation: 'timeLocation',
  StepType.qr: 'qr',
};
