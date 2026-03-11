import 'package:freezed_annotation/freezed_annotation.dart';

part 'validation_config.freezed.dart';
part 'validation_config.g.dart';

@freezed
class ValidationConfig with _$ValidationConfig {
  const factory ValidationConfig({
    required String id,
    required String name,

    // Geofence
    required double radiusM,
    required double minAccuracyM,
    double? maxSpeedMps,
    required bool requireLocationServices,

    // Sampling & timing (Phase 2+)
    required int minAcceptedSamplesToLock,
    required int checkInRequiredPings,
    required int pingRecommendedIntervalSec,
    required int maxStalePingSec,
    required int sessionTtlSec,
    required int timeToValidateSec,

    // Completion (Phase 2+)
    required bool oneTimeOnly,
    int? cooldownSec,

    // Fraud & limits (Phase 2+)
    required int maxActiveSessionsPerUser,
    required bool denyIfMockLocationSuspected,
    @Default('off') String auditLogLevel,
  }) = _ValidationConfig;

  factory ValidationConfig.fromJson(Map<String, dynamic> json) =>
      _$ValidationConfigFromJson(json);
}
