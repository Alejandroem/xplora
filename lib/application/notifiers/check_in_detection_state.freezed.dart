// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'check_in_detection_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CheckInDetectionState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(List<String> candidatePlaceIds) monitoring,
    required TResult Function(Place place, ValidationConfig config,
            double distanceM, Position position)
        inside,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(List<String> candidatePlaceIds)? monitoring,
    TResult? Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(List<String> candidatePlaceIds)? monitoring,
    TResult Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInDetectionInactive value) inactive,
    required TResult Function(CheckInDetectionMonitoring value) monitoring,
    required TResult Function(CheckInDetectionInside value) inside,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInDetectionInactive value)? inactive,
    TResult? Function(CheckInDetectionMonitoring value)? monitoring,
    TResult? Function(CheckInDetectionInside value)? inside,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInDetectionInactive value)? inactive,
    TResult Function(CheckInDetectionMonitoring value)? monitoring,
    TResult Function(CheckInDetectionInside value)? inside,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInDetectionStateCopyWith<$Res> {
  factory $CheckInDetectionStateCopyWith(CheckInDetectionState value,
          $Res Function(CheckInDetectionState) then) =
      _$CheckInDetectionStateCopyWithImpl<$Res, CheckInDetectionState>;
}

/// @nodoc
class _$CheckInDetectionStateCopyWithImpl<$Res,
        $Val extends CheckInDetectionState>
    implements $CheckInDetectionStateCopyWith<$Res> {
  _$CheckInDetectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CheckInDetectionInactiveImplCopyWith<$Res> {
  factory _$$CheckInDetectionInactiveImplCopyWith(
          _$CheckInDetectionInactiveImpl value,
          $Res Function(_$CheckInDetectionInactiveImpl) then) =
      __$$CheckInDetectionInactiveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckInDetectionInactiveImplCopyWithImpl<$Res>
    extends _$CheckInDetectionStateCopyWithImpl<$Res,
        _$CheckInDetectionInactiveImpl>
    implements _$$CheckInDetectionInactiveImplCopyWith<$Res> {
  __$$CheckInDetectionInactiveImplCopyWithImpl(
      _$CheckInDetectionInactiveImpl _value,
      $Res Function(_$CheckInDetectionInactiveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CheckInDetectionInactiveImpl implements CheckInDetectionInactive {
  const _$CheckInDetectionInactiveImpl();

  @override
  String toString() {
    return 'CheckInDetectionState.inactive()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInDetectionInactiveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(List<String> candidatePlaceIds) monitoring,
    required TResult Function(Place place, ValidationConfig config,
            double distanceM, Position position)
        inside,
  }) {
    return inactive();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(List<String> candidatePlaceIds)? monitoring,
    TResult? Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
  }) {
    return inactive?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(List<String> candidatePlaceIds)? monitoring,
    TResult Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
    required TResult orElse(),
  }) {
    if (inactive != null) {
      return inactive();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInDetectionInactive value) inactive,
    required TResult Function(CheckInDetectionMonitoring value) monitoring,
    required TResult Function(CheckInDetectionInside value) inside,
  }) {
    return inactive(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInDetectionInactive value)? inactive,
    TResult? Function(CheckInDetectionMonitoring value)? monitoring,
    TResult? Function(CheckInDetectionInside value)? inside,
  }) {
    return inactive?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInDetectionInactive value)? inactive,
    TResult Function(CheckInDetectionMonitoring value)? monitoring,
    TResult Function(CheckInDetectionInside value)? inside,
    required TResult orElse(),
  }) {
    if (inactive != null) {
      return inactive(this);
    }
    return orElse();
  }
}

abstract class CheckInDetectionInactive implements CheckInDetectionState {
  const factory CheckInDetectionInactive() = _$CheckInDetectionInactiveImpl;
}

/// @nodoc
abstract class _$$CheckInDetectionMonitoringImplCopyWith<$Res> {
  factory _$$CheckInDetectionMonitoringImplCopyWith(
          _$CheckInDetectionMonitoringImpl value,
          $Res Function(_$CheckInDetectionMonitoringImpl) then) =
      __$$CheckInDetectionMonitoringImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> candidatePlaceIds});
}

/// @nodoc
class __$$CheckInDetectionMonitoringImplCopyWithImpl<$Res>
    extends _$CheckInDetectionStateCopyWithImpl<$Res,
        _$CheckInDetectionMonitoringImpl>
    implements _$$CheckInDetectionMonitoringImplCopyWith<$Res> {
  __$$CheckInDetectionMonitoringImplCopyWithImpl(
      _$CheckInDetectionMonitoringImpl _value,
      $Res Function(_$CheckInDetectionMonitoringImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? candidatePlaceIds = null,
  }) {
    return _then(_$CheckInDetectionMonitoringImpl(
      candidatePlaceIds: null == candidatePlaceIds
          ? _value._candidatePlaceIds
          : candidatePlaceIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$CheckInDetectionMonitoringImpl implements CheckInDetectionMonitoring {
  const _$CheckInDetectionMonitoringImpl(
      {required final List<String> candidatePlaceIds})
      : _candidatePlaceIds = candidatePlaceIds;

  final List<String> _candidatePlaceIds;
  @override
  List<String> get candidatePlaceIds {
    if (_candidatePlaceIds is EqualUnmodifiableListView)
      return _candidatePlaceIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_candidatePlaceIds);
  }

  @override
  String toString() {
    return 'CheckInDetectionState.monitoring(candidatePlaceIds: $candidatePlaceIds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInDetectionMonitoringImpl &&
            const DeepCollectionEquality()
                .equals(other._candidatePlaceIds, _candidatePlaceIds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_candidatePlaceIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInDetectionMonitoringImplCopyWith<_$CheckInDetectionMonitoringImpl>
      get copyWith => __$$CheckInDetectionMonitoringImplCopyWithImpl<
          _$CheckInDetectionMonitoringImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(List<String> candidatePlaceIds) monitoring,
    required TResult Function(Place place, ValidationConfig config,
            double distanceM, Position position)
        inside,
  }) {
    return monitoring(candidatePlaceIds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(List<String> candidatePlaceIds)? monitoring,
    TResult? Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
  }) {
    return monitoring?.call(candidatePlaceIds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(List<String> candidatePlaceIds)? monitoring,
    TResult Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
    required TResult orElse(),
  }) {
    if (monitoring != null) {
      return monitoring(candidatePlaceIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInDetectionInactive value) inactive,
    required TResult Function(CheckInDetectionMonitoring value) monitoring,
    required TResult Function(CheckInDetectionInside value) inside,
  }) {
    return monitoring(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInDetectionInactive value)? inactive,
    TResult? Function(CheckInDetectionMonitoring value)? monitoring,
    TResult? Function(CheckInDetectionInside value)? inside,
  }) {
    return monitoring?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInDetectionInactive value)? inactive,
    TResult Function(CheckInDetectionMonitoring value)? monitoring,
    TResult Function(CheckInDetectionInside value)? inside,
    required TResult orElse(),
  }) {
    if (monitoring != null) {
      return monitoring(this);
    }
    return orElse();
  }
}

abstract class CheckInDetectionMonitoring implements CheckInDetectionState {
  const factory CheckInDetectionMonitoring(
          {required final List<String> candidatePlaceIds}) =
      _$CheckInDetectionMonitoringImpl;

  List<String> get candidatePlaceIds;
  @JsonKey(ignore: true)
  _$$CheckInDetectionMonitoringImplCopyWith<_$CheckInDetectionMonitoringImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckInDetectionInsideImplCopyWith<$Res> {
  factory _$$CheckInDetectionInsideImplCopyWith(
          _$CheckInDetectionInsideImpl value,
          $Res Function(_$CheckInDetectionInsideImpl) then) =
      __$$CheckInDetectionInsideImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Place place,
      ValidationConfig config,
      double distanceM,
      Position position});

  $PlaceCopyWith<$Res> get place;
  $ValidationConfigCopyWith<$Res> get config;
}

/// @nodoc
class __$$CheckInDetectionInsideImplCopyWithImpl<$Res>
    extends _$CheckInDetectionStateCopyWithImpl<$Res,
        _$CheckInDetectionInsideImpl>
    implements _$$CheckInDetectionInsideImplCopyWith<$Res> {
  __$$CheckInDetectionInsideImplCopyWithImpl(
      _$CheckInDetectionInsideImpl _value,
      $Res Function(_$CheckInDetectionInsideImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
    Object? config = null,
    Object? distanceM = null,
    Object? position = null,
  }) {
    return _then(_$CheckInDetectionInsideImpl(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as Place,
      config: null == config
          ? _value.config
          : config // ignore: cast_nullable_to_non_nullable
              as ValidationConfig,
      distanceM: null == distanceM
          ? _value.distanceM
          : distanceM // ignore: cast_nullable_to_non_nullable
              as double,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaceCopyWith<$Res> get place {
    return $PlaceCopyWith<$Res>(_value.place, (value) {
      return _then(_value.copyWith(place: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ValidationConfigCopyWith<$Res> get config {
    return $ValidationConfigCopyWith<$Res>(_value.config, (value) {
      return _then(_value.copyWith(config: value));
    });
  }
}

/// @nodoc

class _$CheckInDetectionInsideImpl implements CheckInDetectionInside {
  const _$CheckInDetectionInsideImpl(
      {required this.place,
      required this.config,
      required this.distanceM,
      required this.position});

  @override
  final Place place;
  @override
  final ValidationConfig config;
  @override
  final double distanceM;
  @override
  final Position position;

  @override
  String toString() {
    return 'CheckInDetectionState.inside(place: $place, config: $config, distanceM: $distanceM, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInDetectionInsideImpl &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.config, config) || other.config == config) &&
            (identical(other.distanceM, distanceM) ||
                other.distanceM == distanceM) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, place, config, distanceM, position);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInDetectionInsideImplCopyWith<_$CheckInDetectionInsideImpl>
      get copyWith => __$$CheckInDetectionInsideImplCopyWithImpl<
          _$CheckInDetectionInsideImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() inactive,
    required TResult Function(List<String> candidatePlaceIds) monitoring,
    required TResult Function(Place place, ValidationConfig config,
            double distanceM, Position position)
        inside,
  }) {
    return inside(place, config, distanceM, position);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? inactive,
    TResult? Function(List<String> candidatePlaceIds)? monitoring,
    TResult? Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
  }) {
    return inside?.call(place, config, distanceM, position);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? inactive,
    TResult Function(List<String> candidatePlaceIds)? monitoring,
    TResult Function(Place place, ValidationConfig config, double distanceM,
            Position position)?
        inside,
    required TResult orElse(),
  }) {
    if (inside != null) {
      return inside(place, config, distanceM, position);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckInDetectionInactive value) inactive,
    required TResult Function(CheckInDetectionMonitoring value) monitoring,
    required TResult Function(CheckInDetectionInside value) inside,
  }) {
    return inside(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckInDetectionInactive value)? inactive,
    TResult? Function(CheckInDetectionMonitoring value)? monitoring,
    TResult? Function(CheckInDetectionInside value)? inside,
  }) {
    return inside?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckInDetectionInactive value)? inactive,
    TResult Function(CheckInDetectionMonitoring value)? monitoring,
    TResult Function(CheckInDetectionInside value)? inside,
    required TResult orElse(),
  }) {
    if (inside != null) {
      return inside(this);
    }
    return orElse();
  }
}

abstract class CheckInDetectionInside implements CheckInDetectionState {
  const factory CheckInDetectionInside(
      {required final Place place,
      required final ValidationConfig config,
      required final double distanceM,
      required final Position position}) = _$CheckInDetectionInsideImpl;

  Place get place;
  ValidationConfig get config;
  double get distanceM;
  Position get position;
  @JsonKey(ignore: true)
  _$$CheckInDetectionInsideImplCopyWith<_$CheckInDetectionInsideImpl>
      get copyWith => throw _privateConstructorUsedError;
}
