// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adventure_in_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdventureInProgressImpl _$$AdventureInProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$AdventureInProgressImpl(
      adventure: Adventure.fromJson(json['adventure'] as Map<String, dynamic>),
      enteredPlaceAt: DateTime.parse(json['enteredPlaceAt'] as String),
    );

Map<String, dynamic> _$$AdventureInProgressImplToJson(
        _$AdventureInProgressImpl instance) =>
    <String, dynamic>{
      'adventure': instance.adventure,
      'enteredPlaceAt': instance.enteredPlaceAt.toIso8601String(),
    };
