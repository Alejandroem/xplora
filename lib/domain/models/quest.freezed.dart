// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Quest _$QuestFromJson(Map<String, dynamic> json) {
  return _Quest.fromJson(json);
}

/// @nodoc
mixin _$Quest {
  String? get id => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get questId => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  String get longDescription => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  double get experience => throw _privateConstructorUsedError;
  QuestType get stepType => throw _privateConstructorUsedError;
  int? get timeInSeconds => throw _privateConstructorUsedError;
  double? get stepLatitude => throw _privateConstructorUsedError;
  double? get stepLongitude => throw _privateConstructorUsedError;
  int? get distance => throw _privateConstructorUsedError;
  String? get stepCode => throw _privateConstructorUsedError;
  bool? get hasNotified => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int? get hoursToCompleteAgain => throw _privateConstructorUsedError;

  /// Serializes this Quest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestCopyWith<Quest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestCopyWith<$Res> {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) then) =
      _$QuestCopyWithImpl<$Res, Quest>;
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? questId,
      String? category,
      String title,
      String shortDescription,
      String longDescription,
      String imageUrl,
      double experience,
      QuestType stepType,
      int? timeInSeconds,
      double? stepLatitude,
      double? stepLongitude,
      int? distance,
      String? stepCode,
      bool? hasNotified,
      DateTime? completedAt,
      int? hoursToCompleteAgain});
}

/// @nodoc
class _$QuestCopyWithImpl<$Res, $Val extends Quest>
    implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? questId = freezed,
    Object? category = freezed,
    Object? title = null,
    Object? shortDescription = null,
    Object? longDescription = null,
    Object? imageUrl = null,
    Object? experience = null,
    Object? stepType = null,
    Object? timeInSeconds = freezed,
    Object? stepLatitude = freezed,
    Object? stepLongitude = freezed,
    Object? distance = freezed,
    Object? stepCode = freezed,
    Object? hasNotified = freezed,
    Object? completedAt = freezed,
    Object? hoursToCompleteAgain = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: freezed == questId
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shortDescription: null == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String,
      longDescription: null == longDescription
          ? _value.longDescription
          : longDescription // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as double,
      stepType: null == stepType
          ? _value.stepType
          : stepType // ignore: cast_nullable_to_non_nullable
              as QuestType,
      timeInSeconds: freezed == timeInSeconds
          ? _value.timeInSeconds
          : timeInSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      stepLatitude: freezed == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepLongitude: freezed == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int?,
      stepCode: freezed == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String?,
      hasNotified: freezed == hasNotified
          ? _value.hasNotified
          : hasNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hoursToCompleteAgain: freezed == hoursToCompleteAgain
          ? _value.hoursToCompleteAgain
          : hoursToCompleteAgain // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestImplCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$$QuestImplCopyWith(
          _$QuestImpl value, $Res Function(_$QuestImpl) then) =
      __$$QuestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? questId,
      String? category,
      String title,
      String shortDescription,
      String longDescription,
      String imageUrl,
      double experience,
      QuestType stepType,
      int? timeInSeconds,
      double? stepLatitude,
      double? stepLongitude,
      int? distance,
      String? stepCode,
      bool? hasNotified,
      DateTime? completedAt,
      int? hoursToCompleteAgain});
}

/// @nodoc
class __$$QuestImplCopyWithImpl<$Res>
    extends _$QuestCopyWithImpl<$Res, _$QuestImpl>
    implements _$$QuestImplCopyWith<$Res> {
  __$$QuestImplCopyWithImpl(
      _$QuestImpl _value, $Res Function(_$QuestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? questId = freezed,
    Object? category = freezed,
    Object? title = null,
    Object? shortDescription = null,
    Object? longDescription = null,
    Object? imageUrl = null,
    Object? experience = null,
    Object? stepType = null,
    Object? timeInSeconds = freezed,
    Object? stepLatitude = freezed,
    Object? stepLongitude = freezed,
    Object? distance = freezed,
    Object? stepCode = freezed,
    Object? hasNotified = freezed,
    Object? completedAt = freezed,
    Object? hoursToCompleteAgain = freezed,
  }) {
    return _then(_$QuestImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: freezed == questId
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shortDescription: null == shortDescription
          ? _value.shortDescription
          : shortDescription // ignore: cast_nullable_to_non_nullable
              as String,
      longDescription: null == longDescription
          ? _value.longDescription
          : longDescription // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as double,
      stepType: null == stepType
          ? _value.stepType
          : stepType // ignore: cast_nullable_to_non_nullable
              as QuestType,
      timeInSeconds: freezed == timeInSeconds
          ? _value.timeInSeconds
          : timeInSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      stepLatitude: freezed == stepLatitude
          ? _value.stepLatitude
          : stepLatitude // ignore: cast_nullable_to_non_nullable
              as double?,
      stepLongitude: freezed == stepLongitude
          ? _value.stepLongitude
          : stepLongitude // ignore: cast_nullable_to_non_nullable
              as double?,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int?,
      stepCode: freezed == stepCode
          ? _value.stepCode
          : stepCode // ignore: cast_nullable_to_non_nullable
              as String?,
      hasNotified: freezed == hasNotified
          ? _value.hasNotified
          : hasNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      hoursToCompleteAgain: freezed == hoursToCompleteAgain
          ? _value.hoursToCompleteAgain
          : hoursToCompleteAgain // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestImpl implements _Quest {
  const _$QuestImpl(
      {required this.id,
      required this.userId,
      required this.questId,
      required this.category,
      required this.title,
      required this.shortDescription,
      required this.longDescription,
      required this.imageUrl,
      required this.experience,
      required this.stepType,
      required this.timeInSeconds,
      required this.stepLatitude,
      required this.stepLongitude,
      required this.distance,
      required this.stepCode,
      required this.hasNotified,
      required this.completedAt,
      required this.hoursToCompleteAgain});

  factory _$QuestImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestImplFromJson(json);

  @override
  final String? id;
  @override
  final String? userId;
  @override
  final String? questId;
  @override
  final String? category;
  @override
  final String title;
  @override
  final String shortDescription;
  @override
  final String longDescription;
  @override
  final String imageUrl;
  @override
  final double experience;
  @override
  final QuestType stepType;
  @override
  final int? timeInSeconds;
  @override
  final double? stepLatitude;
  @override
  final double? stepLongitude;
  @override
  final int? distance;
  @override
  final String? stepCode;
  @override
  final bool? hasNotified;
  @override
  final DateTime? completedAt;
  @override
  final int? hoursToCompleteAgain;

  @override
  String toString() {
    return 'Quest(id: $id, userId: $userId, questId: $questId, category: $category, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, imageUrl: $imageUrl, experience: $experience, stepType: $stepType, timeInSeconds: $timeInSeconds, stepLatitude: $stepLatitude, stepLongitude: $stepLongitude, distance: $distance, stepCode: $stepCode, hasNotified: $hasNotified, completedAt: $completedAt, hoursToCompleteAgain: $hoursToCompleteAgain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.questId, questId) || other.questId == questId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.longDescription, longDescription) ||
                other.longDescription == longDescription) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.stepType, stepType) ||
                other.stepType == stepType) &&
            (identical(other.timeInSeconds, timeInSeconds) ||
                other.timeInSeconds == timeInSeconds) &&
            (identical(other.stepLatitude, stepLatitude) ||
                other.stepLatitude == stepLatitude) &&
            (identical(other.stepLongitude, stepLongitude) ||
                other.stepLongitude == stepLongitude) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.stepCode, stepCode) ||
                other.stepCode == stepCode) &&
            (identical(other.hasNotified, hasNotified) ||
                other.hasNotified == hasNotified) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.hoursToCompleteAgain, hoursToCompleteAgain) ||
                other.hoursToCompleteAgain == hoursToCompleteAgain));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      questId,
      category,
      title,
      shortDescription,
      longDescription,
      imageUrl,
      experience,
      stepType,
      timeInSeconds,
      stepLatitude,
      stepLongitude,
      distance,
      stepCode,
      hasNotified,
      completedAt,
      hoursToCompleteAgain);

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestImplCopyWith<_$QuestImpl> get copyWith =>
      __$$QuestImplCopyWithImpl<_$QuestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestImplToJson(
      this,
    );
  }
}

abstract class _Quest implements Quest {
  const factory _Quest(
      {required final String? id,
      required final String? userId,
      required final String? questId,
      required final String? category,
      required final String title,
      required final String shortDescription,
      required final String longDescription,
      required final String imageUrl,
      required final double experience,
      required final QuestType stepType,
      required final int? timeInSeconds,
      required final double? stepLatitude,
      required final double? stepLongitude,
      required final int? distance,
      required final String? stepCode,
      required final bool? hasNotified,
      required final DateTime? completedAt,
      required final int? hoursToCompleteAgain}) = _$QuestImpl;

  factory _Quest.fromJson(Map<String, dynamic> json) = _$QuestImpl.fromJson;

  @override
  String? get id;
  @override
  String? get userId;
  @override
  String? get questId;
  @override
  String? get category;
  @override
  String get title;
  @override
  String get shortDescription;
  @override
  String get longDescription;
  @override
  String get imageUrl;
  @override
  double get experience;
  @override
  QuestType get stepType;
  @override
  int? get timeInSeconds;
  @override
  double? get stepLatitude;
  @override
  double? get stepLongitude;
  @override
  int? get distance;
  @override
  String? get stepCode;
  @override
  bool? get hasNotified;
  @override
  DateTime? get completedAt;
  @override
  int? get hoursToCompleteAgain;

  /// Create a copy of Quest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestImplCopyWith<_$QuestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
