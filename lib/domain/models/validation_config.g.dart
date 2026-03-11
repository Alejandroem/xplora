// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validation_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValidationConfigImpl _$$ValidationConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$ValidationConfigImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      radiusM: (json['radiusM'] as num).toDouble(),
      minAccuracyM: (json['minAccuracyM'] as num).toDouble(),
      maxSpeedMps: (json['maxSpeedMps'] as num?)?.toDouble(),
      requireLocationServices: json['requireLocationServices'] as bool,
      minAcceptedSamplesToLock:
          (json['minAcceptedSamplesToLock'] as num).toInt(),
      checkInRequiredPings: (json['checkInRequiredPings'] as num).toInt(),
      pingRecommendedIntervalSec:
          (json['pingRecommendedIntervalSec'] as num).toInt(),
      maxStalePingSec: (json['maxStalePingSec'] as num).toInt(),
      sessionTtlSec: (json['sessionTtlSec'] as num).toInt(),
      timeToValidateSec: (json['timeToValidateSec'] as num).toInt(),
      oneTimeOnly: json['oneTimeOnly'] as bool,
      cooldownSec: (json['cooldownSec'] as num?)?.toInt(),
      maxActiveSessionsPerUser:
          (json['maxActiveSessionsPerUser'] as num).toInt(),
      denyIfMockLocationSuspected: json['denyIfMockLocationSuspected'] as bool,
      auditLogLevel: json['auditLogLevel'] as String? ?? 'off',
    );

Map<String, dynamic> _$$ValidationConfigImplToJson(
        _$ValidationConfigImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'radiusM': instance.radiusM,
      'minAccuracyM': instance.minAccuracyM,
      'maxSpeedMps': instance.maxSpeedMps,
      'requireLocationServices': instance.requireLocationServices,
      'minAcceptedSamplesToLock': instance.minAcceptedSamplesToLock,
      'checkInRequiredPings': instance.checkInRequiredPings,
      'pingRecommendedIntervalSec': instance.pingRecommendedIntervalSec,
      'maxStalePingSec': instance.maxStalePingSec,
      'sessionTtlSec': instance.sessionTtlSec,
      'timeToValidateSec': instance.timeToValidateSec,
      'oneTimeOnly': instance.oneTimeOnly,
      'cooldownSec': instance.cooldownSec,
      'maxActiveSessionsPerUser': instance.maxActiveSessionsPerUser,
      'denyIfMockLocationSuspected': instance.denyIfMockLocationSuspected,
      'auditLogLevel': instance.auditLogLevel,
    };
