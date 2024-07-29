// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestImpl _$$QuestImplFromJson(Map<String, dynamic> json) => _$QuestImpl(
      title: json['title'] as String,
      shortDescription: json['shortDescription'] as String,
      longDescription: json['longDescription'] as String,
      experience: (json['experience'] as num).toDouble(),
      timeInSeconds: (json['timeInSeconds'] as num).toInt(),
      priceLevel: (json['priceLevel'] as num).toInt(),
      steps: (json['steps'] as List<dynamic>)
          .map((e) => QuestStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestImplToJson(_$QuestImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'shortDescription': instance.shortDescription,
      'longDescription': instance.longDescription,
      'experience': instance.experience,
      'timeInSeconds': instance.timeInSeconds,
      'priceLevel': instance.priceLevel,
      'steps': instance.steps,
    };
