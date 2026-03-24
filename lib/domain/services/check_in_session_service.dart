abstract class CheckInSessionService {
  Future<CheckInStartResult> start({
    required String placeId,
    required double lat,
    required double lng,
    required double accuracyM,
    required double? speedMps,
    required bool isMocked,
  });

  Future<CheckInPingResult> ping({
    required String sessionId,
    required double lat,
    required double lng,
    required double accuracyM,
    required double? speedMps,
  });

  Future<CheckInCompleteResult> complete({
    required String sessionId,
  });
}

class CheckInStartResult {
  final String sessionId;
  final String status;
  final double targetLat;
  final double targetLng;
  final double targetRadiusM;
  final bool requiresQrOrCode;
  final DateTime expiresAt;
  final int pingRecommendedIntervalSec;

  const CheckInStartResult({
    required this.sessionId,
    required this.status,
    required this.targetLat,
    required this.targetLng,
    required this.targetRadiusM,
    required this.requiresQrOrCode,
    required this.expiresAt,
    required this.pingRecommendedIntervalSec,
  });

  @override
  String toString() =>
      'CheckInStartResult(sessionId: $sessionId, status: $status, '
      'targetLat: $targetLat, targetLng: $targetLng, '
      'targetRadiusM: $targetRadiusM, requiresQrOrCode: $requiresQrOrCode, '
      'expiresAt: $expiresAt, pingRecommendedIntervalSec: $pingRecommendedIntervalSec)';
}

class CheckInPingResult {
  final String status;
  final bool inside;
  final double distanceM;
  final double progressPercent;
  final int timeRemainingSec;
  final String? rejectReason;

  const CheckInPingResult({
    required this.status,
    required this.inside,
    required this.distanceM,
    required this.progressPercent,
    required this.timeRemainingSec,
    this.rejectReason,
  });

  @override
  String toString() =>
      'CheckInPingResult(status: $status, inside: $inside, '
      'distanceM: $distanceM, progressPercent: $progressPercent, '
      'timeRemainingSec: $timeRemainingSec, rejectReason: $rejectReason)';
}

class CheckInCompleteResult {
  final bool success;
  final DateTime completedAt;
  final int timesCompleted;
  final DateTime? cooldownUntil;

  const CheckInCompleteResult({
    required this.success,
    required this.completedAt,
    required this.timesCompleted,
    this.cooldownUntil,
  });

  @override
  String toString() =>
      'CheckInCompleteResult(success: $success, completedAt: $completedAt, '
      'timesCompleted: $timesCompleted, cooldownUntil: $cooldownUntil)';
}
