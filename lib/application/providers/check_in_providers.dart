import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/check_in_session_service.dart';
import '../../domain/services/validation_config_service.dart';
import '../../infrastructure/services/firebase_check_in_session_service.dart';
import '../../infrastructure/services/firebase_validation_config_service.dart';
import '../notifiers/check_in_detection_notifier.dart';
import '../notifiers/check_in_detection_state.dart';
import '../notifiers/check_in_session_notifier.dart';
import '../notifiers/check_in_session_state.dart';
import 'location_providers.dart';
import 'place_providers.dart';

final validationConfigServiceProvider =
    Provider<ValidationConfigService>((ref) =>
        FirebaseValidationConfigService());

final checkInDetectionProvider =
    StateNotifierProvider<CheckInDetectionNotifier, CheckInDetectionState>((ref) {
  final notifier = CheckInDetectionNotifier(
    ref,
    ref.watch(validationConfigServiceProvider),
    ref.watch(placeCrudServiceProvider),
  );
  ref.listen(locationTrackingEnabledProvider, (_, next) {
    if (next) notifier.enableLocationTracking();
  });
  return notifier;
});

final checkInSessionServiceProvider =
    Provider<CheckInSessionService>((ref) =>
        FirebaseCheckInSessionService());

final checkInSessionProvider =
    StateNotifierProvider<CheckInSessionNotifier, CheckInSessionState>((ref) {
  final notifier = CheckInSessionNotifier(
    ref,
    ref.watch(checkInSessionServiceProvider),
  );
  ref.listen(checkInDetectionProvider, (prev, next) {
    notifier.onDetectionState(prev, next);
  });
  return notifier;
});
