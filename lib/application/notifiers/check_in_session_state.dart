import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/services/check_in_session_service.dart';

part 'check_in_session_state.freezed.dart';

@freezed
sealed class CheckInSessionState with _$CheckInSessionState {
  /// No active session.
  const factory CheckInSessionState.idle() = CheckInSessionIdle;

  /// /start was called, awaiting server response.
  const factory CheckInSessionState.starting({
    required String placeId,
  }) = CheckInSessionStarting;

  /// Session created successfully. Ready for pinging (Phase 3).
  const factory CheckInSessionState.active({
    required CheckInStartResult session,
    required String placeId,
  }) = CheckInSessionActive;

  /// /start failed with a server error.
  const factory CheckInSessionState.failed({
    required String placeId,
    required String reason,
  }) = CheckInSessionFailed;
}
