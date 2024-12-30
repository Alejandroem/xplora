// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingImpl _$$SettingImplFromJson(Map<String, dynamic> json) =>
    _$SettingImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      key: json['key'] as String,
      value: json['value'],
      variableType: json['variableType'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$SettingImplToJson(_$SettingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'key': instance.key,
      'value': instance.value,
      'variableType': instance.variableType,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
