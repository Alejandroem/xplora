import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/models/place.dart';
import '../../domain/models/validation_config.dart';

part 'check_in_detection_state.freezed.dart';

@freezed
sealed class CheckInDetectionState with _$CheckInDetectionState {
  /// Engine running; no places with validationConfigId within scan range.
  const factory CheckInDetectionState.inactive() = CheckInDetectionInactive;

  /// Engine found checkable candidates; user is not inside any of them.
  const factory CheckInDetectionState.monitoring({
    required List<String> candidatePlaceIds,
  }) = CheckInDetectionMonitoring;

  /// User is within radiusM of this place and detection is geographically reliable.
  /// [position] is the raw GPS reading at the moment of detection — passed to
  /// the session notifier for the /start locationSample payload.
  const factory CheckInDetectionState.inside({
    required Place place,
    required ValidationConfig config,
    required double distanceM,
    required Position position,
  }) = CheckInDetectionInside;
}
