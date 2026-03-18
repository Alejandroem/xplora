abstract class CheckInSessionService {
  Future<CheckInStartResult> start({
    required String placeId,
    required double lat,
    required double lng,
    required double accuracyM,
    required double? speedMps,
    required bool isMocked,
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

  const CheckInStartResult({
    required this.sessionId,
    required this.status,
    required this.targetLat,
    required this.targetLng,
    required this.targetRadiusM,
    required this.requiresQrOrCode,
    required this.expiresAt,
  });

  @override
  String toString() =>
      'CheckInStartResult(sessionId: $sessionId, status: $status, '
      'targetLat: $targetLat, targetLng: $targetLng, '
      'targetRadiusM: $targetRadiusM, requiresQrOrCode: $requiresQrOrCode, '
      'expiresAt: $expiresAt)';
}
