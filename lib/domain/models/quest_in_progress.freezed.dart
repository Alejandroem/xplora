// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_in_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestInProgress _$QuestInProgressFromJson(Map<String, dynamic> json) {
  return _QuestInProgress.fromJson(json);
}

/// @nodoc
mixin _$QuestInProgress {
  Quest get quest => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  int? get timeInArea => throw _privateConstructorUsedError;

  /// Serializes this QuestInProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestInProgressCopyWith<QuestInProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestInProgressCopyWith<$Res> {
  factory $QuestInProgressCopyWith(
          QuestInProgress value, $Res Function(QuestInProgress) then) =
      _$QuestInProgressCopyWithImpl<$Res, QuestInProgress>;
  @useResult
  $Res call({Quest quest, DateTime startedAt, int? timeInArea});

  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class _$QuestInProgressCopyWithImpl<$Res, $Val extends QuestInProgress>
    implements $QuestInProgressCopyWith<$Res> {
  _$QuestInProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quest = null,
    Object? startedAt = null,
    Object? timeInArea = freezed,
  }) {
    return _then(_value.copyWith(
      quest: null == quest
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeInArea: freezed == timeInArea
          ? _value.timeInArea
          : timeInArea // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuestCopyWith<$Res> get quest {
    return $QuestCopyWith<$Res>(_value.quest, (value) {
      return _then(_value.copyWith(quest: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestInProgressImplCopyWith<$Res>
    implements $QuestInProgressCopyWith<$Res> {
  factory _$$QuestInProgressImplCopyWith(_$QuestInProgressImpl value,
          $Res Function(_$QuestInProgressImpl) then) =
      __$$QuestInProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Quest quest, DateTime startedAt, int? timeInArea});

  @override
  $QuestCopyWith<$Res> get quest;
}

/// @nodoc
class __$$QuestInProgressImplCopyWithImpl<$Res>
    extends _$QuestInProgressCopyWithImpl<$Res, _$QuestInProgressImpl>
    implements _$$QuestInProgressImplCopyWith<$Res> {
  __$$QuestInProgressImplCopyWithImpl(
      _$QuestInProgressImpl _value, $Res Function(_$QuestInProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quest = null,
    Object? startedAt = null,
    Object? timeInArea = freezed,
  }) {
    return _then(_$QuestInProgressImpl(
      quest: null == quest
          ? _value.quest
          : quest // ignore: cast_nullable_to_non_nullable
              as Quest,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      timeInArea: freezed == timeInArea
          ? _value.timeInArea
          : timeInArea // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestInProgressImpl implements _QuestInProgress {
  const _$QuestInProgressImpl(
      {required this.quest, required this.startedAt, this.timeInArea});

  factory _$QuestInProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestInProgressImplFromJson(json);

  @override
  final Quest quest;
  @override
  final DateTime startedAt;
  @override
  final int? timeInArea;

  @override
  String toString() {
    return 'QuestInProgress(quest: $quest, startedAt: $startedAt, timeInArea: $timeInArea)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestInProgressImpl &&
            (identical(other.quest, quest) || other.quest == quest) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.timeInArea, timeInArea) ||
                other.timeInArea == timeInArea));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quest, startedAt, timeInArea);

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestInProgressImplCopyWith<_$QuestInProgressImpl> get copyWith =>
      __$$QuestInProgressImplCopyWithImpl<_$QuestInProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestInProgressImplToJson(
      this,
    );
  }
}

abstract class _QuestInProgress implements QuestInProgress {
  const factory _QuestInProgress(
      {required final Quest quest,
      required final DateTime startedAt,
      final int? timeInArea}) = _$QuestInProgressImpl;

  factory _QuestInProgress.fromJson(Map<String, dynamic> json) =
      _$QuestInProgressImpl.fromJson;

  @override
  Quest get quest;
  @override
  DateTime get startedAt;
  @override
  int? get timeInArea;

  /// Create a copy of QuestInProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestInProgressImplCopyWith<_$QuestInProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
