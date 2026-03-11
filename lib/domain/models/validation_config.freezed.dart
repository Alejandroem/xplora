// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'validation_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValidationConfig _$ValidationConfigFromJson(Map<String, dynamic> json) {
  return _ValidationConfig.fromJson(json);
}

/// @nodoc
mixin _$ValidationConfig {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError; // Geofence
  double get radiusM => throw _privateConstructorUsedError;
  double get minAccuracyM => throw _privateConstructorUsedError;
  double? get maxSpeedMps => throw _privateConstructorUsedError;
  bool get requireLocationServices =>
      throw _privateConstructorUsedError; // Sampling & timing (Phase 2+)
  int get minAcceptedSamplesToLock => throw _privateConstructorUsedError;
  int get checkInRequiredPings => throw _privateConstructorUsedError;
  int get pingRecommendedIntervalSec => throw _privateConstructorUsedError;
  int get maxStalePingSec => throw _privateConstructorUsedError;
  int get sessionTtlSec => throw _privateConstructorUsedError;
  int get timeToValidateSec =>
      throw _privateConstructorUsedError; // Completion (Phase 2+)
  bool get oneTimeOnly => throw _privateConstructorUsedError;
  int? get cooldownSec =>
      throw _privateConstructorUsedError; // Fraud & limits (Phase 2+)
  int get maxActiveSessionsPerUser => throw _privateConstructorUsedError;
  bool get denyIfMockLocationSuspected => throw _privateConstructorUsedError;
  String get auditLogLevel => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValidationConfigCopyWith<ValidationConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValidationConfigCopyWith<$Res> {
  factory $ValidationConfigCopyWith(
          ValidationConfig value, $Res Function(ValidationConfig) then) =
      _$ValidationConfigCopyWithImpl<$Res, ValidationConfig>;
  @useResult
  $Res call(
      {String id,
      String name,
      double radiusM,
      double minAccuracyM,
      double? maxSpeedMps,
      bool requireLocationServices,
      int minAcceptedSamplesToLock,
      int checkInRequiredPings,
      int pingRecommendedIntervalSec,
      int maxStalePingSec,
      int sessionTtlSec,
      int timeToValidateSec,
      bool oneTimeOnly,
      int? cooldownSec,
      int maxActiveSessionsPerUser,
      bool denyIfMockLocationSuspected,
      String auditLogLevel});
}

/// @nodoc
class _$ValidationConfigCopyWithImpl<$Res, $Val extends ValidationConfig>
    implements $ValidationConfigCopyWith<$Res> {
  _$ValidationConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? radiusM = null,
    Object? minAccuracyM = null,
    Object? maxSpeedMps = freezed,
    Object? requireLocationServices = null,
    Object? minAcceptedSamplesToLock = null,
    Object? checkInRequiredPings = null,
    Object? pingRecommendedIntervalSec = null,
    Object? maxStalePingSec = null,
    Object? sessionTtlSec = null,
    Object? timeToValidateSec = null,
    Object? oneTimeOnly = null,
    Object? cooldownSec = freezed,
    Object? maxActiveSessionsPerUser = null,
    Object? denyIfMockLocationSuspected = null,
    Object? auditLogLevel = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      radiusM: null == radiusM
          ? _value.radiusM
          : radiusM // ignore: cast_nullable_to_non_nullable
              as double,
      minAccuracyM: null == minAccuracyM
          ? _value.minAccuracyM
          : minAccuracyM // ignore: cast_nullable_to_non_nullable
              as double,
      maxSpeedMps: freezed == maxSpeedMps
          ? _value.maxSpeedMps
          : maxSpeedMps // ignore: cast_nullable_to_non_nullable
              as double?,
      requireLocationServices: null == requireLocationServices
          ? _value.requireLocationServices
          : requireLocationServices // ignore: cast_nullable_to_non_nullable
              as bool,
      minAcceptedSamplesToLock: null == minAcceptedSamplesToLock
          ? _value.minAcceptedSamplesToLock
          : minAcceptedSamplesToLock // ignore: cast_nullable_to_non_nullable
              as int,
      checkInRequiredPings: null == checkInRequiredPings
          ? _value.checkInRequiredPings
          : checkInRequiredPings // ignore: cast_nullable_to_non_nullable
              as int,
      pingRecommendedIntervalSec: null == pingRecommendedIntervalSec
          ? _value.pingRecommendedIntervalSec
          : pingRecommendedIntervalSec // ignore: cast_nullable_to_non_nullable
              as int,
      maxStalePingSec: null == maxStalePingSec
          ? _value.maxStalePingSec
          : maxStalePingSec // ignore: cast_nullable_to_non_nullable
              as int,
      sessionTtlSec: null == sessionTtlSec
          ? _value.sessionTtlSec
          : sessionTtlSec // ignore: cast_nullable_to_non_nullable
              as int,
      timeToValidateSec: null == timeToValidateSec
          ? _value.timeToValidateSec
          : timeToValidateSec // ignore: cast_nullable_to_non_nullable
              as int,
      oneTimeOnly: null == oneTimeOnly
          ? _value.oneTimeOnly
          : oneTimeOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      cooldownSec: freezed == cooldownSec
          ? _value.cooldownSec
          : cooldownSec // ignore: cast_nullable_to_non_nullable
              as int?,
      maxActiveSessionsPerUser: null == maxActiveSessionsPerUser
          ? _value.maxActiveSessionsPerUser
          : maxActiveSessionsPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      denyIfMockLocationSuspected: null == denyIfMockLocationSuspected
          ? _value.denyIfMockLocationSuspected
          : denyIfMockLocationSuspected // ignore: cast_nullable_to_non_nullable
              as bool,
      auditLogLevel: null == auditLogLevel
          ? _value.auditLogLevel
          : auditLogLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValidationConfigImplCopyWith<$Res>
    implements $ValidationConfigCopyWith<$Res> {
  factory _$$ValidationConfigImplCopyWith(_$ValidationConfigImpl value,
          $Res Function(_$ValidationConfigImpl) then) =
      __$$ValidationConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double radiusM,
      double minAccuracyM,
      double? maxSpeedMps,
      bool requireLocationServices,
      int minAcceptedSamplesToLock,
      int checkInRequiredPings,
      int pingRecommendedIntervalSec,
      int maxStalePingSec,
      int sessionTtlSec,
      int timeToValidateSec,
      bool oneTimeOnly,
      int? cooldownSec,
      int maxActiveSessionsPerUser,
      bool denyIfMockLocationSuspected,
      String auditLogLevel});
}

/// @nodoc
class __$$ValidationConfigImplCopyWithImpl<$Res>
    extends _$ValidationConfigCopyWithImpl<$Res, _$ValidationConfigImpl>
    implements _$$ValidationConfigImplCopyWith<$Res> {
  __$$ValidationConfigImplCopyWithImpl(_$ValidationConfigImpl _value,
      $Res Function(_$ValidationConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? radiusM = null,
    Object? minAccuracyM = null,
    Object? maxSpeedMps = freezed,
    Object? requireLocationServices = null,
    Object? minAcceptedSamplesToLock = null,
    Object? checkInRequiredPings = null,
    Object? pingRecommendedIntervalSec = null,
    Object? maxStalePingSec = null,
    Object? sessionTtlSec = null,
    Object? timeToValidateSec = null,
    Object? oneTimeOnly = null,
    Object? cooldownSec = freezed,
    Object? maxActiveSessionsPerUser = null,
    Object? denyIfMockLocationSuspected = null,
    Object? auditLogLevel = null,
  }) {
    return _then(_$ValidationConfigImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      radiusM: null == radiusM
          ? _value.radiusM
          : radiusM // ignore: cast_nullable_to_non_nullable
              as double,
      minAccuracyM: null == minAccuracyM
          ? _value.minAccuracyM
          : minAccuracyM // ignore: cast_nullable_to_non_nullable
              as double,
      maxSpeedMps: freezed == maxSpeedMps
          ? _value.maxSpeedMps
          : maxSpeedMps // ignore: cast_nullable_to_non_nullable
              as double?,
      requireLocationServices: null == requireLocationServices
          ? _value.requireLocationServices
          : requireLocationServices // ignore: cast_nullable_to_non_nullable
              as bool,
      minAcceptedSamplesToLock: null == minAcceptedSamplesToLock
          ? _value.minAcceptedSamplesToLock
          : minAcceptedSamplesToLock // ignore: cast_nullable_to_non_nullable
              as int,
      checkInRequiredPings: null == checkInRequiredPings
          ? _value.checkInRequiredPings
          : checkInRequiredPings // ignore: cast_nullable_to_non_nullable
              as int,
      pingRecommendedIntervalSec: null == pingRecommendedIntervalSec
          ? _value.pingRecommendedIntervalSec
          : pingRecommendedIntervalSec // ignore: cast_nullable_to_non_nullable
              as int,
      maxStalePingSec: null == maxStalePingSec
          ? _value.maxStalePingSec
          : maxStalePingSec // ignore: cast_nullable_to_non_nullable
              as int,
      sessionTtlSec: null == sessionTtlSec
          ? _value.sessionTtlSec
          : sessionTtlSec // ignore: cast_nullable_to_non_nullable
              as int,
      timeToValidateSec: null == timeToValidateSec
          ? _value.timeToValidateSec
          : timeToValidateSec // ignore: cast_nullable_to_non_nullable
              as int,
      oneTimeOnly: null == oneTimeOnly
          ? _value.oneTimeOnly
          : oneTimeOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      cooldownSec: freezed == cooldownSec
          ? _value.cooldownSec
          : cooldownSec // ignore: cast_nullable_to_non_nullable
              as int?,
      maxActiveSessionsPerUser: null == maxActiveSessionsPerUser
          ? _value.maxActiveSessionsPerUser
          : maxActiveSessionsPerUser // ignore: cast_nullable_to_non_nullable
              as int,
      denyIfMockLocationSuspected: null == denyIfMockLocationSuspected
          ? _value.denyIfMockLocationSuspected
          : denyIfMockLocationSuspected // ignore: cast_nullable_to_non_nullable
              as bool,
      auditLogLevel: null == auditLogLevel
          ? _value.auditLogLevel
          : auditLogLevel // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValidationConfigImpl implements _ValidationConfig {
  const _$ValidationConfigImpl(
      {required this.id,
      required this.name,
      required this.radiusM,
      required this.minAccuracyM,
      this.maxSpeedMps,
      required this.requireLocationServices,
      required this.minAcceptedSamplesToLock,
      required this.checkInRequiredPings,
      required this.pingRecommendedIntervalSec,
      required this.maxStalePingSec,
      required this.sessionTtlSec,
      required this.timeToValidateSec,
      required this.oneTimeOnly,
      this.cooldownSec,
      required this.maxActiveSessionsPerUser,
      required this.denyIfMockLocationSuspected,
      this.auditLogLevel = 'off'});

  factory _$ValidationConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValidationConfigImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
// Geofence
  @override
  final double radiusM;
  @override
  final double minAccuracyM;
  @override
  final double? maxSpeedMps;
  @override
  final bool requireLocationServices;
// Sampling & timing (Phase 2+)
  @override
  final int minAcceptedSamplesToLock;
  @override
  final int checkInRequiredPings;
  @override
  final int pingRecommendedIntervalSec;
  @override
  final int maxStalePingSec;
  @override
  final int sessionTtlSec;
  @override
  final int timeToValidateSec;
// Completion (Phase 2+)
  @override
  final bool oneTimeOnly;
  @override
  final int? cooldownSec;
// Fraud & limits (Phase 2+)
  @override
  final int maxActiveSessionsPerUser;
  @override
  final bool denyIfMockLocationSuspected;
  @override
  @JsonKey()
  final String auditLogLevel;

  @override
  String toString() {
    return 'ValidationConfig(id: $id, name: $name, radiusM: $radiusM, minAccuracyM: $minAccuracyM, maxSpeedMps: $maxSpeedMps, requireLocationServices: $requireLocationServices, minAcceptedSamplesToLock: $minAcceptedSamplesToLock, checkInRequiredPings: $checkInRequiredPings, pingRecommendedIntervalSec: $pingRecommendedIntervalSec, maxStalePingSec: $maxStalePingSec, sessionTtlSec: $sessionTtlSec, timeToValidateSec: $timeToValidateSec, oneTimeOnly: $oneTimeOnly, cooldownSec: $cooldownSec, maxActiveSessionsPerUser: $maxActiveSessionsPerUser, denyIfMockLocationSuspected: $denyIfMockLocationSuspected, auditLogLevel: $auditLogLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationConfigImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.radiusM, radiusM) || other.radiusM == radiusM) &&
            (identical(other.minAccuracyM, minAccuracyM) ||
                other.minAccuracyM == minAccuracyM) &&
            (identical(other.maxSpeedMps, maxSpeedMps) ||
                other.maxSpeedMps == maxSpeedMps) &&
            (identical(other.requireLocationServices, requireLocationServices) ||
                other.requireLocationServices == requireLocationServices) &&
            (identical(other.minAcceptedSamplesToLock, minAcceptedSamplesToLock) ||
                other.minAcceptedSamplesToLock == minAcceptedSamplesToLock) &&
            (identical(other.checkInRequiredPings, checkInRequiredPings) ||
                other.checkInRequiredPings == checkInRequiredPings) &&
            (identical(other.pingRecommendedIntervalSec,
                    pingRecommendedIntervalSec) ||
                other.pingRecommendedIntervalSec ==
                    pingRecommendedIntervalSec) &&
            (identical(other.maxStalePingSec, maxStalePingSec) ||
                other.maxStalePingSec == maxStalePingSec) &&
            (identical(other.sessionTtlSec, sessionTtlSec) ||
                other.sessionTtlSec == sessionTtlSec) &&
            (identical(other.timeToValidateSec, timeToValidateSec) ||
                other.timeToValidateSec == timeToValidateSec) &&
            (identical(other.oneTimeOnly, oneTimeOnly) ||
                other.oneTimeOnly == oneTimeOnly) &&
            (identical(other.cooldownSec, cooldownSec) ||
                other.cooldownSec == cooldownSec) &&
            (identical(
                    other.maxActiveSessionsPerUser, maxActiveSessionsPerUser) ||
                other.maxActiveSessionsPerUser == maxActiveSessionsPerUser) &&
            (identical(other.denyIfMockLocationSuspected,
                    denyIfMockLocationSuspected) ||
                other.denyIfMockLocationSuspected ==
                    denyIfMockLocationSuspected) &&
            (identical(other.auditLogLevel, auditLogLevel) ||
                other.auditLogLevel == auditLogLevel));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      radiusM,
      minAccuracyM,
      maxSpeedMps,
      requireLocationServices,
      minAcceptedSamplesToLock,
      checkInRequiredPings,
      pingRecommendedIntervalSec,
      maxStalePingSec,
      sessionTtlSec,
      timeToValidateSec,
      oneTimeOnly,
      cooldownSec,
      maxActiveSessionsPerUser,
      denyIfMockLocationSuspected,
      auditLogLevel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationConfigImplCopyWith<_$ValidationConfigImpl> get copyWith =>
      __$$ValidationConfigImplCopyWithImpl<_$ValidationConfigImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ValidationConfigImplToJson(
      this,
    );
  }
}

abstract class _ValidationConfig implements ValidationConfig {
  const factory _ValidationConfig(
      {required final String id,
      required final String name,
      required final double radiusM,
      required final double minAccuracyM,
      final double? maxSpeedMps,
      required final bool requireLocationServices,
      required final int minAcceptedSamplesToLock,
      required final int checkInRequiredPings,
      required final int pingRecommendedIntervalSec,
      required final int maxStalePingSec,
      required final int sessionTtlSec,
      required final int timeToValidateSec,
      required final bool oneTimeOnly,
      final int? cooldownSec,
      required final int maxActiveSessionsPerUser,
      required final bool denyIfMockLocationSuspected,
      final String auditLogLevel}) = _$ValidationConfigImpl;

  factory _ValidationConfig.fromJson(Map<String, dynamic> json) =
      _$ValidationConfigImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override // Geofence
  double get radiusM;
  @override
  double get minAccuracyM;
  @override
  double? get maxSpeedMps;
  @override
  bool get requireLocationServices;
  @override // Sampling & timing (Phase 2+)
  int get minAcceptedSamplesToLock;
  @override
  int get checkInRequiredPings;
  @override
  int get pingRecommendedIntervalSec;
  @override
  int get maxStalePingSec;
  @override
  int get sessionTtlSec;
  @override
  int get timeToValidateSec;
  @override // Completion (Phase 2+)
  bool get oneTimeOnly;
  @override
  int? get cooldownSec;
  @override // Fraud & limits (Phase 2+)
  int get maxActiveSessionsPerUser;
  @override
  bool get denyIfMockLocationSuspected;
  @override
  String get auditLogLevel;
  @override
  @JsonKey(ignore: true)
  _$$ValidationConfigImplCopyWith<_$ValidationConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
