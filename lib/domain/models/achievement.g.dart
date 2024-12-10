// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AchievementImpl _$$AchievementImplFromJson(Map<String, dynamic> json) =>
    _$AchievementImpl(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      dateAchieved: DateTime.parse(json['dateAchieved'] as String),
      trigger: $enumDecode(_$TriggerEnumMap, json['trigger']),
      triggerValue: json['triggerValue'] as String,
    );

Map<String, dynamic> _$$AchievementImplToJson(_$AchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'dateAchieved': instance.dateAchieved.toIso8601String(),
      'trigger': _$TriggerEnumMap[instance.trigger]!,
      'triggerValue': instance.triggerValue,
    };

const _$TriggerEnumMap = {
  Trigger.experience: 'experience',
  Trigger.level: 'level',
  Trigger.adventure: 'adventure',
  Trigger.quest: 'quest',
};
