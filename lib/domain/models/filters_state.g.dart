// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filters_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FiltersStateImpl _$$FiltersStateImplFromJson(Map<String, dynamic> json) =>
    _$FiltersStateImpl(
      selectedType: json['selectedType'] as String? ?? 'All',
      minimumDistance: (json['minimumDistance'] as num?)?.toInt() ?? 500000,
      filtersEnabled: json['filtersEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$FiltersStateImplToJson(_$FiltersStateImpl instance) =>
    <String, dynamic>{
      'selectedType': instance.selectedType,
      'minimumDistance': instance.minimumDistance,
      'filtersEnabled': instance.filtersEnabled,
    };
