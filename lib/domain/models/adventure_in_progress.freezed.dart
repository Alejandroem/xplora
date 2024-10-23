// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adventure_in_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdventureInProgress _$AdventureInProgressFromJson(Map<String, dynamic> json) {
  return _AdventureInProgress.fromJson(json);
}

/// @nodoc
mixin _$AdventureInProgress {
  Adventure get adventure => throw _privateConstructorUsedError;
  DateTime get enteredPlaceAt => throw _privateConstructorUsedError;
  int get completeness => throw _privateConstructorUsedError;

  /// Serializes this AdventureInProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdventureInProgressCopyWith<AdventureInProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdventureInProgressCopyWith<$Res> {
  factory $AdventureInProgressCopyWith(
          AdventureInProgress value, $Res Function(AdventureInProgress) then) =
      _$AdventureInProgressCopyWithImpl<$Res, AdventureInProgress>;
  @useResult
  $Res call({Adventure adventure, DateTime enteredPlaceAt, int completeness});

  $AdventureCopyWith<$Res> get adventure;
}

/// @nodoc
class _$AdventureInProgressCopyWithImpl<$Res, $Val extends AdventureInProgress>
    implements $AdventureInProgressCopyWith<$Res> {
  _$AdventureInProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adventure = null,
    Object? enteredPlaceAt = null,
    Object? completeness = null,
  }) {
    return _then(_value.copyWith(
      adventure: null == adventure
          ? _value.adventure
          : adventure // ignore: cast_nullable_to_non_nullable
              as Adventure,
      enteredPlaceAt: null == enteredPlaceAt
          ? _value.enteredPlaceAt
          : enteredPlaceAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completeness: null == completeness
          ? _value.completeness
          : completeness // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdventureCopyWith<$Res> get adventure {
    return $AdventureCopyWith<$Res>(_value.adventure, (value) {
      return _then(_value.copyWith(adventure: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdventureInProgressImplCopyWith<$Res>
    implements $AdventureInProgressCopyWith<$Res> {
  factory _$$AdventureInProgressImplCopyWith(_$AdventureInProgressImpl value,
          $Res Function(_$AdventureInProgressImpl) then) =
      __$$AdventureInProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Adventure adventure, DateTime enteredPlaceAt, int completeness});

  @override
  $AdventureCopyWith<$Res> get adventure;
}

/// @nodoc
class __$$AdventureInProgressImplCopyWithImpl<$Res>
    extends _$AdventureInProgressCopyWithImpl<$Res, _$AdventureInProgressImpl>
    implements _$$AdventureInProgressImplCopyWith<$Res> {
  __$$AdventureInProgressImplCopyWithImpl(_$AdventureInProgressImpl _value,
      $Res Function(_$AdventureInProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adventure = null,
    Object? enteredPlaceAt = null,
    Object? completeness = null,
  }) {
    return _then(_$AdventureInProgressImpl(
      adventure: null == adventure
          ? _value.adventure
          : adventure // ignore: cast_nullable_to_non_nullable
              as Adventure,
      enteredPlaceAt: null == enteredPlaceAt
          ? _value.enteredPlaceAt
          : enteredPlaceAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completeness: null == completeness
          ? _value.completeness
          : completeness // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdventureInProgressImpl implements _AdventureInProgress {
  const _$AdventureInProgressImpl(
      {required this.adventure,
      required this.enteredPlaceAt,
      required this.completeness});

  factory _$AdventureInProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdventureInProgressImplFromJson(json);

  @override
  final Adventure adventure;
  @override
  final DateTime enteredPlaceAt;
  @override
  final int completeness;

  @override
  String toString() {
    return 'AdventureInProgress(adventure: $adventure, enteredPlaceAt: $enteredPlaceAt, completeness: $completeness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdventureInProgressImpl &&
            (identical(other.adventure, adventure) ||
                other.adventure == adventure) &&
            (identical(other.enteredPlaceAt, enteredPlaceAt) ||
                other.enteredPlaceAt == enteredPlaceAt) &&
            (identical(other.completeness, completeness) ||
                other.completeness == completeness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, adventure, enteredPlaceAt, completeness);

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdventureInProgressImplCopyWith<_$AdventureInProgressImpl> get copyWith =>
      __$$AdventureInProgressImplCopyWithImpl<_$AdventureInProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdventureInProgressImplToJson(
      this,
    );
  }
}

abstract class _AdventureInProgress implements AdventureInProgress {
  const factory _AdventureInProgress(
      {required final Adventure adventure,
      required final DateTime enteredPlaceAt,
      required final int completeness}) = _$AdventureInProgressImpl;

  factory _AdventureInProgress.fromJson(Map<String, dynamic> json) =
      _$AdventureInProgressImpl.fromJson;

  @override
  Adventure get adventure;
  @override
  DateTime get enteredPlaceAt;
  @override
  int get completeness;

  /// Create a copy of AdventureInProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdventureInProgressImplCopyWith<_$AdventureInProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
