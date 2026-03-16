import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

import '../../domain/services/check_in_session_service.dart';

class FirebaseCheckInSessionService implements CheckInSessionService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String?> _getDeviceIdHash() async {
    try {
      final info = DeviceInfoPlugin();
      String rawId;
      if (Platform.isAndroid) {
        rawId = (await info.androidInfo).id;
      } else if (Platform.isIOS) {
        rawId = (await info.iosInfo).identifierForVendor ?? '';
      } else {
        return null;
      }
      final bytes = utf8.encode(rawId);
      return sha256.convert(bytes).toString();
    } catch (e) {
      debugPrint('CheckInSession: failed to get device ID hash – $e');
      return null;
    }
  }

  @override
  Future<CheckInStartResult> start({
    required String placeId,
    required double lat,
    required double lng,
    required double accuracyM,
    required double? speedMps,
    required bool isMocked,
  }) async {
    final deviceIdHash = await _getDeviceIdHash();

    final callable = _functions.httpsCallable('validateStart');
    final result = await callable.call<Map<String, dynamic>>({
      'scopeType': 'PLACE',
      'scopeId': placeId,
      'mode': 'CHECKIN',
      'locationSample': {
        'lat': lat,
        'lng': lng,
        'accuracyM': accuracyM,
        'speedMps': speedMps,
        'clientTs': DateTime.now().millisecondsSinceEpoch,
        'isMocked': isMocked,
      },
      if (deviceIdHash != null)
        'deviceInfo': {'deviceIdHash': deviceIdHash},
    });

    final data = result.data;
    final target = data['target'] as Map<String, dynamic>;

    return CheckInStartResult(
      sessionId: data['sessionId'] as String,
      status: data['status'] as String,
      targetLat: (target['lat'] as num).toDouble(),
      targetLng: (target['lng'] as num).toDouble(),
      targetRadiusM: (target['radiusM'] as num).toDouble(),
      requiresQrOrCode: data['requiresQrOrCode'] as bool,
      expiresAt: DateTime.fromMillisecondsSinceEpoch(data['expiresAt'] as int),
    );
  }
}
