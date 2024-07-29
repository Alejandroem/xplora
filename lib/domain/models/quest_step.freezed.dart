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
  String get stepName => throw _privateConstructorUsedError;
  String get stepDescription => throw _privateConstructorUsedError;
  String get stepCode => throw _privateConstructorUsedError;
  double get stepLatitude => throw _privateConstructorUsedError;
  double get stepLongitude => throw _privateConstructorUsedError;

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
      {String stepName,
      String stepDescription,
      String stepCode,
      double stepLatitude,
      double stepLongitude});
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
    Object? stepName = null,
    Object? stepDescription = null,
    Object? stepCode = null,
    Object? stepLatitude = null,
    Object? stepLongitude = null,
  }) {
    return _then(_value.copyWith(
      stepName: null == stepName
          ? _value.stepName
          : stepName // ignore: cast_nullable_to_non_nullable
              as String,
      stepDescription: null == stepDescription
          ? _value.stepDescription
          : stepDescription // ignore: cast_nullable_to_non_nullable
              as String,
      stepCode: null == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String,
      stepLatitude: null == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      stepLongitude: null == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double,
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
      {String stepName,
      String stepDescription,
      String stepCode,
      double stepLatitude,
      double stepLongitude});
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
    Object? stepName = null,
    Object? stepDescription = null,
    Object? stepCode = null,
    Object? stepLatitude = null,
    Object? stepLongitude = null,
  }) {
    return _then(_$QuestStepImpl(
      stepName: null == stepName
          ? _value.stepName
          : stepName // ignore: cast_nullable_to_non_nullable
              as String,
      stepDescription: null == stepDescription
          ? _value.stepDescription
          : stepDescription // ignore: cast_nullable_to_non_nullable
              as String,
      stepCode: null == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String,
      stepLatitude: null == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double,
      stepLongitude: null == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestStepImpl implements _QuestStep {
  const _$QuestStepImpl(
      {required this.stepName,
      required this.stepDescription,
      required this.stepCode,
      required this.stepLatitude,
      required this.stepLongitude});

  factory _$QuestStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestStepImplFromJson(json);

  @override
  final String stepName;
  @override
  final String stepDescription;
  @override
  final String stepCode;
  @override
  final double stepLatitude;
  @override
  final double stepLongitude;

  @override
  String toString() {
    return 'QuestStep(stepName: $stepName, stepDescription: $stepDescription, stepCode: $stepCode, stepLatitude: $stepLatitude, stepLongitude: $stepLongitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestStepImpl &&
            (identical(other.stepName, stepName) ||
                other.stepName == stepName) &&
            (identical(other.stepDescription, stepDescription) ||
                other.stepDescription == stepDescription) &&
            (identical(other.stepCode, stepCode) ||
                other.stepCode == stepCode) &&
            (identical(other.stepLatitude, stepLatitude) ||
                other.stepLatitude == stepLatitude) &&
            (identical(other.stepLongitude, stepLongitude) ||
                other.stepLongitude == stepLongitude));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stepName, stepDescription,
      stepCode, stepLatitude, stepLongitude);

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
      {required final String stepName,
      required final String stepDescription,
      required final String stepCode,
      required final double stepLatitude,
      required final double stepLongitude}) = _$QuestStepImpl;

  factory _QuestStep.fromJson(Map<String, dynamic> json) =
      _$QuestStepImpl.fromJson;

  @override
  String get stepName;
  @override
  String get stepDescription;
  @override
  String get stepCode;
  @override
  double get stepLatitude;
  @override
  double get stepLongitude;
  @override
  @JsonKey(ignore: true)
  _$$QuestStepImplCopyWith<_$QuestStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
