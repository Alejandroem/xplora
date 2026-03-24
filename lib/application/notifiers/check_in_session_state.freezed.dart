// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_session_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckInSessionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInSessionStateCopyWith<$Res> {
  factory $CheckInSessionStateCopyWith(
          CheckInSessionState value, $Res Function(CheckInSessionState) then) =
      _$CheckInSessionStateCopyWithImpl<$Res, CheckInSessionState>;
}

/// @nodoc
class _$CheckInSessionStateCopyWithImpl<$Res, $Val extends CheckInSessionState>
    implements $CheckInSessionStateCopyWith<$Res> {
  _$CheckInSessionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CheckInSessionIdleImplCopyWith<$Res> {
  factory _$$CheckInSessionIdleImplCopyWith(_$CheckInSessionIdleImpl value,
          $Res Function(_$CheckInSessionIdleImpl) then) =
      __$$CheckInSessionIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckInSessionIdleImplCopyWithImpl<$Res>
    extends _$CheckInSessionStateCopyWithImpl<$Res, _$CheckInSessionIdleImpl>
    implements _$$CheckInSessionIdleImplCopyWith<$Res> {
  __$$CheckInSessionIdleImplCopyWithImpl(_$CheckInSessionIdleImpl _value,
      $Res Function(_$CheckInSessionIdleImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CheckInSessionIdleImpl implements CheckInSessionIdle {
  const _$CheckInSessionIdleImpl();

  @override
  String toString() {
    return 'CheckInSessionState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckInSessionIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class CheckInSessionIdle implements CheckInSessionState {
  const factory CheckInSessionIdle() = _$CheckInSessionIdleImpl;
}

/// @nodoc
abstract class _$$CheckInSessionStartingImplCopyWith<$Res> {
  factory _$$CheckInSessionStartingImplCopyWith(
          _$CheckInSessionStartingImpl value,
          $Res Function(_$CheckInSessionStartingImpl) then) =
      __$$CheckInSessionStartingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String placeId});
}

/// @nodoc
class __$$CheckInSessionStartingImplCopyWithImpl<$Res>
    extends _$CheckInSessionStateCopyWithImpl<$Res,
        _$CheckInSessionStartingImpl>
    implements _$$CheckInSessionStartingImplCopyWith<$Res> {
  __$$CheckInSessionStartingImplCopyWithImpl(
      _$CheckInSessionStartingImpl _value,
      $Res Function(_$CheckInSessionStartingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
  }) {
    return _then(_$CheckInSessionStartingImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CheckInSessionStartingImpl implements CheckInSessionStarting {
  const _$CheckInSessionStartingImpl({required this.placeId});

  @override
  final String placeId;

  @override
  String toString() {
    return 'CheckInSessionState.starting(placeId: $placeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInSessionStartingImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInSessionStartingImplCopyWith<_$CheckInSessionStartingImpl>
      get copyWith => __$$CheckInSessionStartingImplCopyWithImpl<
          _$CheckInSessionStartingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) {
    return starting(placeId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) {
    return starting?.call(placeId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting(placeId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) {
    return starting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) {
    return starting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (starting != null) {
      return starting(this);
    }
    return orElse();
  }
}

abstract class CheckInSessionStarting implements CheckInSessionState {
  const factory CheckInSessionStarting({required final String placeId}) =
      _$CheckInSessionStartingImpl;

  String get placeId;
  @JsonKey(ignore: true)
  _$$CheckInSessionStartingImplCopyWith<_$CheckInSessionStartingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckInSessionActiveImplCopyWith<$Res> {
  factory _$$CheckInSessionActiveImplCopyWith(_$CheckInSessionActiveImpl value,
          $Res Function(_$CheckInSessionActiveImpl) then) =
      __$$CheckInSessionActiveImplCopyWithImpl<$Res>;
  @useResult
  $Res call({CheckInStartResult session, String placeId});
}

/// @nodoc
class __$$CheckInSessionActiveImplCopyWithImpl<$Res>
    extends _$CheckInSessionStateCopyWithImpl<$Res, _$CheckInSessionActiveImpl>
    implements _$$CheckInSessionActiveImplCopyWith<$Res> {
  __$$CheckInSessionActiveImplCopyWithImpl(_$CheckInSessionActiveImpl _value,
      $Res Function(_$CheckInSessionActiveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? placeId = null,
  }) {
    return _then(_$CheckInSessionActiveImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as CheckInStartResult,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CheckInSessionActiveImpl implements CheckInSessionActive {
  const _$CheckInSessionActiveImpl(
      {required this.session, required this.placeId});

  @override
  final CheckInStartResult session;
  @override
  final String placeId;

  @override
  String toString() {
    return 'CheckInSessionState.active(session: $session, placeId: $placeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInSessionActiveImpl &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.placeId, placeId) || other.placeId == placeId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, session, placeId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInSessionActiveImplCopyWith<_$CheckInSessionActiveImpl>
      get copyWith =>
          __$$CheckInSessionActiveImplCopyWithImpl<_$CheckInSessionActiveImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) {
    return active(session, placeId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) {
    return active?.call(session, placeId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(session, placeId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) {
    return active(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) {
    return active?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (active != null) {
      return active(this);
    }
    return orElse();
  }
}

abstract class CheckInSessionActive implements CheckInSessionState {
  const factory CheckInSessionActive(
      {required final CheckInStartResult session,
      required final String placeId}) = _$CheckInSessionActiveImpl;

  CheckInStartResult get session;
  String get placeId;
  @JsonKey(ignore: true)
  _$$CheckInSessionActiveImplCopyWith<_$CheckInSessionActiveImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckInSessionFailedImplCopyWith<$Res> {
  factory _$$CheckInSessionFailedImplCopyWith(_$CheckInSessionFailedImpl value,
          $Res Function(_$CheckInSessionFailedImpl) then) =
      __$$CheckInSessionFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String placeId, String reason});
}

/// @nodoc
class __$$CheckInSessionFailedImplCopyWithImpl<$Res>
    extends _$CheckInSessionStateCopyWithImpl<$Res, _$CheckInSessionFailedImpl>
    implements _$$CheckInSessionFailedImplCopyWith<$Res> {
  __$$CheckInSessionFailedImplCopyWithImpl(_$CheckInSessionFailedImpl _value,
      $Res Function(_$CheckInSessionFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? reason = null,
  }) {
    return _then(_$CheckInSessionFailedImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CheckInSessionFailedImpl implements CheckInSessionFailed {
  const _$CheckInSessionFailedImpl(
      {required this.placeId, required this.reason});

  @override
  final String placeId;
  @override
  final String reason;

  @override
  String toString() {
    return 'CheckInSessionState.failed(placeId: $placeId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInSessionFailedImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInSessionFailedImplCopyWith<_$CheckInSessionFailedImpl>
      get copyWith =>
          __$$CheckInSessionFailedImplCopyWithImpl<_$CheckInSessionFailedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) {
    return failed(placeId, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) {
    return failed?.call(placeId, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(placeId, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class CheckInSessionFailed implements CheckInSessionState {
  const factory CheckInSessionFailed(
      {required final String placeId,
      required final String reason}) = _$CheckInSessionFailedImpl;

  String get placeId;
  String get reason;
  @JsonKey(ignore: true)
  _$$CheckInSessionFailedImplCopyWith<_$CheckInSessionFailedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckInSessionCompletedImplCopyWith<$Res> {
  factory _$$CheckInSessionCompletedImplCopyWith(
          _$CheckInSessionCompletedImpl value,
          $Res Function(_$CheckInSessionCompletedImpl) then) =
      __$$CheckInSessionCompletedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String placeId, CheckInCompleteResult result});
}

/// @nodoc
class __$$CheckInSessionCompletedImplCopyWithImpl<$Res>
    extends _$CheckInSessionStateCopyWithImpl<$Res,
        _$CheckInSessionCompletedImpl>
    implements _$$CheckInSessionCompletedImplCopyWith<$Res> {
  __$$CheckInSessionCompletedImplCopyWithImpl(
      _$CheckInSessionCompletedImpl _value,
      $Res Function(_$CheckInSessionCompletedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? result = null,
  }) {
    return _then(_$CheckInSessionCompletedImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as CheckInCompleteResult,
    ));
  }
}

/// @nodoc

class _$CheckInSessionCompletedImpl implements CheckInSessionCompleted {
  const _$CheckInSessionCompletedImpl(
      {required this.placeId, required this.result});

  @override
  final String placeId;
  @override
  final CheckInCompleteResult result;

  @override
  String toString() {
    return 'CheckInSessionState.completed(placeId: $placeId, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInSessionCompletedImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, placeId, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInSessionCompletedImplCopyWith<_$CheckInSessionCompletedImpl>
      get copyWith => __$$CheckInSessionCompletedImplCopyWithImpl<
          _$CheckInSessionCompletedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function(String placeId) starting,
    required TResult Function(CheckInStartResult session, String placeId)
        active,
    required TResult Function(String placeId, String reason) failed,
    required TResult Function(String placeId, CheckInCompleteResult result)
        completed,
  }) {
    return completed(placeId, result);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function(String placeId)? starting,
    TResult? Function(CheckInStartResult session, String placeId)? active,
    TResult? Function(String placeId, String reason)? failed,
    TResult? Function(String placeId, CheckInCompleteResult result)? completed,
  }) {
    return completed?.call(placeId, result);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function(String placeId)? starting,
    TResult Function(CheckInStartResult session, String placeId)? active,
    TResult Function(String placeId, String reason)? failed,
    TResult Function(String placeId, CheckInCompleteResult result)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(placeId, result);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInSessionIdle value) idle,
    required TResult Function(CheckInSessionStarting value) starting,
    required TResult Function(CheckInSessionActive value) active,
    required TResult Function(CheckInSessionFailed value) failed,
    required TResult Function(CheckInSessionCompleted value) completed,
  }) {
    return completed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInSessionIdle value)? idle,
    TResult? Function(CheckInSessionStarting value)? starting,
    TResult? Function(CheckInSessionActive value)? active,
    TResult? Function(CheckInSessionFailed value)? failed,
    TResult? Function(CheckInSessionCompleted value)? completed,
  }) {
    return completed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInSessionIdle value)? idle,
    TResult Function(CheckInSessionStarting value)? starting,
    TResult Function(CheckInSessionActive value)? active,
    TResult Function(CheckInSessionFailed value)? failed,
    TResult Function(CheckInSessionCompleted value)? completed,
    required TResult orElse(),
  }) {
    if (completed != null) {
      return completed(this);
    }
    return orElse();
  }
}

abstract class CheckInSessionCompleted implements CheckInSessionState {
  const factory CheckInSessionCompleted(
          {required final String placeId,
          required final CheckInCompleteResult result}) =
      _$CheckInSessionCompletedImpl;

  String get placeId;
  CheckInCompleteResult get result;
  @JsonKey(ignore: true)
  _$$CheckInSessionCompletedImplCopyWith<_$CheckInSessionCompletedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
