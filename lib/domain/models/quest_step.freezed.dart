// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestStep _$QuestStepFromJson(Map<String, dynamic> json) {
  return _QuestStep.fromJson(json);
}

/// @nodoc
mixin _$QuestStep {
  @deprecated
  String? get id => throw _privateConstructorUsedError;
  @deprecated
  String? get questId => throw _privateConstructorUsedError;
  bool? get completed => throw _privateConstructorUsedError;
  String get stepName => throw _privateConstructorUsedError;
  String get stepDescription => throw _privateConstructorUsedError;
  StepType get stepType => throw _privateConstructorUsedError;
  double? get stepLatitude => throw _privateConstructorUsedError;
  double? get stepLongitude => throw _privateConstructorUsedError;
  String? get stepCode => throw _privateConstructorUsedError;
  int? get stepTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestStepCopyWith<QuestStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestStepCopyWith<$Res> {
  factory $QuestStepCopyWith(QuestStep value, $Res Function(QuestStep) then) =
      _$QuestStepCopyWithImpl<$Res, QuestStep>;
  @useResult
  $Res call(
      {@deprecated String? id,
      @deprecated String? questId,
      bool? completed,
      String stepName,
      String stepDescription,
      StepType stepType,
      double? stepLatitude,
      double? stepLongitude,
      String? stepCode,
      int? stepTime});
}

/// @nodoc
class _$QuestStepCopyWithImpl<$Res, $Val extends QuestStep>
    implements $QuestStepCopyWith<$Res> {
  _$QuestStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questId = freezed,
    Object? completed = freezed,
    Object? stepName = null,
    Object? stepDescription = null,
    Object? stepType = null,
    Object? stepLatitude = freezed,
    Object? stepLongitude = freezed,
    Object? stepCode = freezed,
    Object? stepTime = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: freezed == questId
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      stepName: null == stepName
          ? _value.stepName
          : stepName // ignore: cast_nullable_to_non_nullable
              as String,
      stepDescription: null == stepDescription
          ? _value.stepDescription
          : stepDescription // ignore: cast_nullable_to_non_nullable
              as String,
      stepType: null == stepType
          ? _value.stepType
          : stepType // ignore: cast_nullable_to_non_nullable
              as StepType,
      stepLatitude: freezed == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepLongitude: freezed == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepCode: freezed == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String?,
      stepTime: freezed == stepTime
          ? _value.stepTime
          : stepTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestStepImplCopyWith<$Res>
    implements $QuestStepCopyWith<$Res> {
  factory _$$QuestStepImplCopyWith(
          _$QuestStepImpl value, $Res Function(_$QuestStepImpl) then) =
      __$$QuestStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@deprecated String? id,
      @deprecated String? questId,
      bool? completed,
      String stepName,
      String stepDescription,
      StepType stepType,
      double? stepLatitude,
      double? stepLongitude,
      String? stepCode,
      int? stepTime});
}

/// @nodoc
class __$$QuestStepImplCopyWithImpl<$Res>
    extends _$QuestStepCopyWithImpl<$Res, _$QuestStepImpl>
    implements _$$QuestStepImplCopyWith<$Res> {
  __$$QuestStepImplCopyWithImpl(
      _$QuestStepImpl _value, $Res Function(_$QuestStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? questId = freezed,
    Object? completed = freezed,
    Object? stepName = null,
    Object? stepDescription = null,
    Object? stepType = null,
    Object? stepLatitude = freezed,
    Object? stepLongitude = freezed,
    Object? stepCode = freezed,
    Object? stepTime = freezed,
  }) {
    return _then(_$QuestStepImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: freezed == questId
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      completed: freezed == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool?,
      stepName: null == stepName
          ? _value.stepName
          : stepName // ignore: cast_nullable_to_non_nullable
              as String,
      stepDescription: null == stepDescription
          ? _value.stepDescription
          : stepDescription // ignore: cast_nullable_to_non_nullable
              as String,
      stepType: null == stepType
          ? _value.stepType
          : stepType // ignore: cast_nullable_to_non_nullable
              as StepType,
      stepLatitude: freezed == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepLongitude: freezed == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepCode: freezed == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String?,
      stepTime: freezed == stepTime
          ? _value.stepTime
          : stepTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestStepImpl implements _QuestStep {
  const _$QuestStepImpl(
      {@deprecated required this.id,
      @deprecated required this.questId,
      required this.completed,
      required this.stepName,
      required this.stepDescription,
      required this.stepType,
      required this.stepLatitude,
      required this.stepLongitude,
      required this.stepCode,
      required this.stepTime});

  factory _$QuestStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestStepImplFromJson(json);

  @override
  @deprecated
  final String? id;
  @override
  @deprecated
  final String? questId;
  @override
  final bool? completed;
  @override
  final String stepName;
  @override
  final String stepDescription;
  @override
  final StepType stepType;
  @override
  final double? stepLatitude;
  @override
  final double? stepLongitude;
  @override
  final String? stepCode;
  @override
  final int? stepTime;

  @override
  String toString() {
    return 'QuestStep(id: $id, questId: $questId, completed: $completed, stepName: $stepName, stepDescription: $stepDescription, stepType: $stepType, stepLatitude: $stepLatitude, stepLongitude: $stepLongitude, stepCode: $stepCode, stepTime: $stepTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestStepImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questId, questId) || other.questId == questId) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.stepName, stepName) ||
                other.stepName == stepName) &&
            (identical(other.stepDescription, stepDescription) ||
                other.stepDescription == stepDescription) &&
            (identical(other.stepType, stepType) ||
                other.stepType == stepType) &&
            (identical(other.stepLatitude, stepLatitude) ||
                other.stepLatitude == stepLatitude) &&
            (identical(other.stepLongitude, stepLongitude) ||
                other.stepLongitude == stepLongitude) &&
            (identical(other.stepCode, stepCode) ||
                other.stepCode == stepCode) &&
            (identical(other.stepTime, stepTime) ||
                other.stepTime == stepTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      questId,
      completed,
      stepName,
      stepDescription,
      stepType,
      stepLatitude,
      stepLongitude,
      stepCode,
      stepTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestStepImplCopyWith<_$QuestStepImpl> get copyWith =>
      __$$QuestStepImplCopyWithImpl<_$QuestStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestStepImplToJson(
      this,
    );
  }
}

abstract class _QuestStep implements QuestStep {
  const factory _QuestStep(
      {@deprecated required final String? id,
      @deprecated required final String? questId,
      required final bool? completed,
      required final String stepName,
      required final String stepDescription,
      required final StepType stepType,
      required final double? stepLatitude,
      required final double? stepLongitude,
      required final String? stepCode,
      required final int? stepTime}) = _$QuestStepImpl;

  factory _QuestStep.fromJson(Map<String, dynamic> json) =
      _$QuestStepImpl.fromJson;

  @override
  @deprecated
  String? get id;
  @override
  @deprecated
  String? get questId;
  @override
  bool? get completed;
  @override
  String get stepName;
  @override
  String get stepDescription;
  @override
  StepType get stepType;
  @override
  double? get stepLatitude;
  @override
  double? get stepLongitude;
  @override
  String? get stepCode;
  @override
  int? get stepTime;
  @override
  @JsonKey(ignore: true)
  _$$QuestStepImplCopyWith<_$QuestStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
