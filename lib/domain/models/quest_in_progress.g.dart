// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_in_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestInProgressImpl _$$QuestInProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestInProgressImpl(
      quest: Quest.fromJson(json['quest'] as Map<String, dynamic>),
      startedAt: DateTime.parse(json['startedAt'] as String),
      timeInArea: (json['timeInArea'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$QuestInProgressImplToJson(
        _$QuestInProgressImpl instance) =>
    <String, dynamic>{
      'quest': instance.quest,
      'startedAt': instance.startedAt.toIso8601String(),
      'timeInArea': instance.timeInArea,
    };
