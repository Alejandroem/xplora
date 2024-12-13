// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adventure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Adventure _$AdventureFromJson(Map<String, dynamic> json) {
  return _Adventure.fromJson(json);
}

/// @nodoc
mixin _$Adventure {
  String? get id => throw _privateConstructorUsedError;
  String? get userId =>
      throw _privateConstructorUsedError; //Only set if a user already got through it
  String? get adventureId =>
      throw _privateConstructorUsedError; //Only set if a user already got through it as it should be the old adventure id
  String? get category => throw _privateConstructorUsedError;
  bool? get featured => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get shortDescription => throw _privateConstructorUsedError;
  String get longDescription => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  List<String>? get featuredImages => throw _privateConstructorUsedError;
  double get experience => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int? get distance => throw _privateConstructorUsedError;
  bool? get hasNotified => throw _privateConstructorUsedError;
  int? get timeInSeconds => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  int? get hoursToCompleteAgain => throw _privateConstructorUsedError;

  /// Serializes this Adventure to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Adventure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdventureCopyWith<Adventure> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdventureCopyWith<$Res> {
  factory $AdventureCopyWith(Adventure value, $Res Function(Adventure) then) =
      _$AdventureCopyWithImpl<$Res, Adventure>;
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? adventureId,
      String? category,
      bool? featured,
      String title,
      String shortDescription,
      String longDescription,
      String imageUrl,
      List<String>? featuredImages,
      double experience,
      double latitude,
      double longitude,
      int? distance,
      bool? hasNotified,
      int? timeInSeconds,
      DateTime? completedAt,
      int? hoursToCompleteAgain});
}

/// @nodoc
class _$AdventureCopyWithImpl<$Res, $Val extends Adventure>
    implements $AdventureCopyWith<$Res> {
  _$AdventureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Adventure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? adventureId = freezed,
    Object? category = freezed,
    Object? featured = freezed,
    Object? title = null,
    Object? shortDescription = null,
    Object? longDescription = null,
    Object? imageUrl = null,
    Object? featuredImages = freezed,
    Object? experience = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distance = freezed,
    Object? hasNotified = freezed,
    Object? timeInSeconds = freezed,
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
      adventureId: freezed == adventureId
          ? _value.adventureId
          : adventureId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      featured: freezed == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      featuredImages: freezed == featuredImages
          ? _value.featuredImages
          : featuredImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNotified: freezed == hasNotified
          ? _value.hasNotified
          : hasNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      timeInSeconds: freezed == timeInSeconds
          ? _value.timeInSeconds
          : timeInSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$AdventureImplCopyWith<$Res>
    implements $AdventureCopyWith<$Res> {
  factory _$$AdventureImplCopyWith(
          _$AdventureImpl value, $Res Function(_$AdventureImpl) then) =
      __$$AdventureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? userId,
      String? adventureId,
      String? category,
      bool? featured,
      String title,
      String shortDescription,
      String longDescription,
      String imageUrl,
      List<String>? featuredImages,
      double experience,
      double latitude,
      double longitude,
      int? distance,
      bool? hasNotified,
      int? timeInSeconds,
      DateTime? completedAt,
      int? hoursToCompleteAgain});
}

/// @nodoc
class __$$AdventureImplCopyWithImpl<$Res>
    extends _$AdventureCopyWithImpl<$Res, _$AdventureImpl>
    implements _$$AdventureImplCopyWith<$Res> {
  __$$AdventureImplCopyWithImpl(
      _$AdventureImpl _value, $Res Function(_$AdventureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Adventure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? adventureId = freezed,
    Object? category = freezed,
    Object? featured = freezed,
    Object? title = null,
    Object? shortDescription = null,
    Object? longDescription = null,
    Object? imageUrl = null,
    Object? featuredImages = freezed,
    Object? experience = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? distance = freezed,
    Object? hasNotified = freezed,
    Object? timeInSeconds = freezed,
    Object? completedAt = freezed,
    Object? hoursToCompleteAgain = freezed,
  }) {
    return _then(_$AdventureImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      adventureId: freezed == adventureId
          ? _value.adventureId
          : adventureId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      featured: freezed == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool?,
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
      featuredImages: freezed == featuredImages
          ? _value._featuredImages
          : featuredImages // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as double,
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      distance: freezed == distance
          ? _value.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as int?,
      hasNotified: freezed == hasNotified
          ? _value.hasNotified
          : hasNotified // ignore: cast_nullable_to_non_nullable
              as bool?,
      timeInSeconds: freezed == timeInSeconds
          ? _value.timeInSeconds
          : timeInSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$AdventureImpl implements _Adventure {
  const _$AdventureImpl(
      {required this.id,
      required this.userId,
      required this.adventureId,
      required this.category,
      required this.featured,
      required this.title,
      required this.shortDescription,
      required this.longDescription,
      required this.imageUrl,
      required final List<String>? featuredImages,
      required this.experience,
      required this.latitude,
      required this.longitude,
      required this.distance,
      required this.hasNotified,
      required this.timeInSeconds,
      required this.completedAt,
      required this.hoursToCompleteAgain})
      : _featuredImages = featuredImages;

  factory _$AdventureImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdventureImplFromJson(json);

  @override
  final String? id;
  @override
  final String? userId;
//Only set if a user already got through it
  @override
  final String? adventureId;
//Only set if a user already got through it as it should be the old adventure id
  @override
  final String? category;
  @override
  final bool? featured;
  @override
  final String title;
  @override
  final String shortDescription;
  @override
  final String longDescription;
  @override
  final String imageUrl;
  final List<String>? _featuredImages;
  @override
  List<String>? get featuredImages {
    final value = _featuredImages;
    if (value == null) return null;
    if (_featuredImages is EqualUnmodifiableListView) return _featuredImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final double experience;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int? distance;
  @override
  final bool? hasNotified;
  @override
  final int? timeInSeconds;
  @override
  final DateTime? completedAt;
  @override
  final int? hoursToCompleteAgain;

  @override
  String toString() {
    return 'Adventure(id: $id, userId: $userId, adventureId: $adventureId, category: $category, featured: $featured, title: $title, shortDescription: $shortDescription, longDescription: $longDescription, imageUrl: $imageUrl, featuredImages: $featuredImages, experience: $experience, latitude: $latitude, longitude: $longitude, distance: $distance, hasNotified: $hasNotified, timeInSeconds: $timeInSeconds, completedAt: $completedAt, hoursToCompleteAgain: $hoursToCompleteAgain)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdventureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.adventureId, adventureId) ||
                other.adventureId == adventureId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shortDescription, shortDescription) ||
                other.shortDescription == shortDescription) &&
            (identical(other.longDescription, longDescription) ||
                other.longDescription == longDescription) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._featuredImages, _featuredImages) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.hasNotified, hasNotified) ||
                other.hasNotified == hasNotified) &&
            (identical(other.timeInSeconds, timeInSeconds) ||
                other.timeInSeconds == timeInSeconds) &&
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
      adventureId,
      category,
      featured,
      title,
      shortDescription,
      longDescription,
      imageUrl,
      const DeepCollectionEquality().hash(_featuredImages),
      experience,
      latitude,
      longitude,
      distance,
      hasNotified,
      timeInSeconds,
      completedAt,
      hoursToCompleteAgain);

  /// Create a copy of Adventure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdventureImplCopyWith<_$AdventureImpl> get copyWith =>
      __$$AdventureImplCopyWithImpl<_$AdventureImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdventureImplToJson(
      this,
    );
  }
}

abstract class _Adventure implements Adventure {
  const factory _Adventure(
      {required final String? id,
      required final String? userId,
      required final String? adventureId,
      required final String? category,
      required final bool? featured,
      required final String title,
      required final String shortDescription,
      required final String longDescription,
      required final String imageUrl,
      required final List<String>? featuredImages,
      required final double experience,
      required final double latitude,
      required final double longitude,
      required final int? distance,
      required final bool? hasNotified,
      required final int? timeInSeconds,
      required final DateTime? completedAt,
      required final int? hoursToCompleteAgain}) = _$AdventureImpl;

  factory _Adventure.fromJson(Map<String, dynamic> json) =
      _$AdventureImpl.fromJson;

  @override
  String? get id;
  @override
  String? get userId; //Only set if a user already got through it
  @override
  String?
      get adventureId; //Only set if a user already got through it as it should be the old adventure id
  @override
  String? get category;
  @override
  bool? get featured;
  @override
  String get title;
  @override
  String get shortDescription;
  @override
  String get longDescription;
  @override
  String get imageUrl;
  @override
  List<String>? get featuredImages;
  @override
  double get experience;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int? get distance;
  @override
  bool? get hasNotified;
  @override
  int? get timeInSeconds;
  @override
  DateTime? get completedAt;
  @override
  int? get hoursToCompleteAgain;

  /// Create a copy of Adventure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdventureImplCopyWith<_$AdventureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
