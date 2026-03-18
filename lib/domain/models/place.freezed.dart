// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategorySelection _$CategorySelectionFromJson(Map<String, dynamic> json) {
  return _CategorySelection.fromJson(json);
}

/// @nodoc
mixin _$CategorySelection {
  String get selectedId => throw _privateConstructorUsedError;
  List<String> get path => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategorySelectionCopyWith<CategorySelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorySelectionCopyWith<$Res> {
  factory $CategorySelectionCopyWith(
          CategorySelection value, $Res Function(CategorySelection) then) =
      _$CategorySelectionCopyWithImpl<$Res, CategorySelection>;
  @useResult
  $Res call({String selectedId, List<String> path});
}

/// @nodoc
class _$CategorySelectionCopyWithImpl<$Res, $Val extends CategorySelection>
    implements $CategorySelectionCopyWith<$Res> {
  _$CategorySelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedId = null,
    Object? path = null,
  }) {
    return _then(_value.copyWith(
      selectedId: null == selectedId
          ? _value.selectedId
          : selectedId // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorySelectionImplCopyWith<$Res>
    implements $CategorySelectionCopyWith<$Res> {
  factory _$$CategorySelectionImplCopyWith(_$CategorySelectionImpl value,
          $Res Function(_$CategorySelectionImpl) then) =
      __$$CategorySelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedId, List<String> path});
}

/// @nodoc
class __$$CategorySelectionImplCopyWithImpl<$Res>
    extends _$CategorySelectionCopyWithImpl<$Res, _$CategorySelectionImpl>
    implements _$$CategorySelectionImplCopyWith<$Res> {
  __$$CategorySelectionImplCopyWithImpl(_$CategorySelectionImpl _value,
      $Res Function(_$CategorySelectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedId = null,
    Object? path = null,
  }) {
    return _then(_$CategorySelectionImpl(
      selectedId: null == selectedId
          ? _value.selectedId
          : selectedId // ignore: cast_nullable_to_non_nullable
              as String,
      path: null == path
          ? _value._path
          : path // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorySelectionImpl implements _CategorySelection {
  const _$CategorySelectionImpl(
      {required this.selectedId, final List<String> path = const []})
      : _path = path;

  factory _$CategorySelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategorySelectionImplFromJson(json);

  @override
  final String selectedId;
  final List<String> _path;
  @override
  @JsonKey()
  List<String> get path {
    if (_path is EqualUnmodifiableListView) return _path;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_path);
  }

  @override
  String toString() {
    return 'CategorySelection(selectedId: $selectedId, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorySelectionImpl &&
            (identical(other.selectedId, selectedId) ||
                other.selectedId == selectedId) &&
            const DeepCollectionEquality().equals(other._path, _path));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, selectedId, const DeepCollectionEquality().hash(_path));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorySelectionImplCopyWith<_$CategorySelectionImpl> get copyWith =>
      __$$CategorySelectionImplCopyWithImpl<_$CategorySelectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorySelectionImplToJson(
      this,
    );
  }
}

abstract class _CategorySelection implements CategorySelection {
  const factory _CategorySelection(
      {required final String selectedId,
      final List<String> path}) = _$CategorySelectionImpl;

  factory _CategorySelection.fromJson(Map<String, dynamic> json) =
      _$CategorySelectionImpl.fromJson;

  @override
  String get selectedId;
  @override
  List<String> get path;
  @override
  @JsonKey(ignore: true)
  _$$CategorySelectionImplCopyWith<_$CategorySelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Place _$PlaceFromJson(Map<String, dynamic> json) {
  return _Place.fromJson(json);
}

/// @nodoc
mixin _$Place {
  String get placeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, dynamic> get geo => throw _privateConstructorUsedError;
  List<CategorySelection> get categorySelections =>
      throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  ValidationConfig? get validationConfig => throw _privateConstructorUsedError;
  int get xp => throw _privateConstructorUsedError;
  int get contributionXp => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String? get rejectionReason => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceCopyWith<Place> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceCopyWith<$Res> {
  factory $PlaceCopyWith(Place value, $Res Function(Place) then) =
      _$PlaceCopyWithImpl<$Res, Place>;
  @useResult
  $Res call(
      {String placeId,
      String name,
      Map<String, dynamic> geo,
      List<CategorySelection> categorySelections,
      List<String> imageUrls,
      String? location,
      String? description,
      ValidationConfig? validationConfig,
      int xp,
      int contributionXp,
      String? userId,
      String? rejectionReason,
      String source,
      String status,
      @TimestampConverter() Timestamp? createdAt,
      @TimestampConverter() Timestamp? updatedAt});

  $ValidationConfigCopyWith<$Res>? get validationConfig;
}

/// @nodoc
class _$PlaceCopyWithImpl<$Res, $Val extends Place>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? geo = null,
    Object? categorySelections = null,
    Object? imageUrls = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? validationConfig = freezed,
    Object? xp = null,
    Object? contributionXp = null,
    Object? userId = freezed,
    Object? rejectionReason = freezed,
    Object? source = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      geo: null == geo
          ? _value.geo
          : geo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      categorySelections: null == categorySelections
          ? _value.categorySelections
          : categorySelections // ignore: cast_nullable_to_non_nullable
              as List<CategorySelection>,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      validationConfig: freezed == validationConfig
          ? _value.validationConfig
          : validationConfig // ignore: cast_nullable_to_non_nullable
              as ValidationConfig?,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      contributionXp: null == contributionXp
          ? _value.contributionXp
          : contributionXp // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ValidationConfigCopyWith<$Res>? get validationConfig {
    if (_value.validationConfig == null) {
      return null;
    }

    return $ValidationConfigCopyWith<$Res>(_value.validationConfig!, (value) {
      return _then(_value.copyWith(validationConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceImplCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$$PlaceImplCopyWith(
          _$PlaceImpl value, $Res Function(_$PlaceImpl) then) =
      __$$PlaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String placeId,
      String name,
      Map<String, dynamic> geo,
      List<CategorySelection> categorySelections,
      List<String> imageUrls,
      String? location,
      String? description,
      ValidationConfig? validationConfig,
      int xp,
      int contributionXp,
      String? userId,
      String? rejectionReason,
      String source,
      String status,
      @TimestampConverter() Timestamp? createdAt,
      @TimestampConverter() Timestamp? updatedAt});

  @override
  $ValidationConfigCopyWith<$Res>? get validationConfig;
}

/// @nodoc
class __$$PlaceImplCopyWithImpl<$Res>
    extends _$PlaceCopyWithImpl<$Res, _$PlaceImpl>
    implements _$$PlaceImplCopyWith<$Res> {
  __$$PlaceImplCopyWithImpl(
      _$PlaceImpl _value, $Res Function(_$PlaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? geo = null,
    Object? categorySelections = null,
    Object? imageUrls = null,
    Object? location = freezed,
    Object? description = freezed,
    Object? validationConfig = freezed,
    Object? xp = null,
    Object? contributionXp = null,
    Object? userId = freezed,
    Object? rejectionReason = freezed,
    Object? source = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PlaceImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      geo: null == geo
          ? _value._geo
          : geo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      categorySelections: null == categorySelections
          ? _value._categorySelections
          : categorySelections // ignore: cast_nullable_to_non_nullable
              as List<CategorySelection>,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      validationConfig: freezed == validationConfig
          ? _value.validationConfig
          : validationConfig // ignore: cast_nullable_to_non_nullable
              as ValidationConfig?,
      xp: null == xp
          ? _value.xp
          : xp // ignore: cast_nullable_to_non_nullable
              as int,
      contributionXp: null == contributionXp
          ? _value.contributionXp
          : contributionXp // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as Timestamp?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceImpl implements _Place {
  const _$PlaceImpl(
      {required this.placeId,
      required this.name,
      required final Map<String, dynamic> geo,
      final List<CategorySelection> categorySelections = const [],
      final List<String> imageUrls = const [],
      this.location,
      this.description,
      this.validationConfig,
      this.xp = 0,
      this.contributionXp = 0,
      this.userId,
      this.rejectionReason,
      this.source = 'seed',
      this.status = 'active',
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt})
      : _geo = geo,
        _categorySelections = categorySelections,
        _imageUrls = imageUrls;

  factory _$PlaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceImplFromJson(json);

  @override
  final String placeId;
  @override
  final String name;
  final Map<String, dynamic> _geo;
  @override
  Map<String, dynamic> get geo {
    if (_geo is EqualUnmodifiableMapView) return _geo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_geo);
  }

  final List<CategorySelection> _categorySelections;
  @override
  @JsonKey()
  List<CategorySelection> get categorySelections {
    if (_categorySelections is EqualUnmodifiableListView)
      return _categorySelections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categorySelections);
  }

  final List<String> _imageUrls;
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  final String? location;
  @override
  final String? description;
  @override
  final ValidationConfig? validationConfig;
  @override
  @JsonKey()
  final int xp;
  @override
  @JsonKey()
  final int contributionXp;
  @override
  final String? userId;
  @override
  final String? rejectionReason;
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String status;
  @override
  @TimestampConverter()
  final Timestamp? createdAt;
  @override
  @TimestampConverter()
  final Timestamp? updatedAt;

  @override
  String toString() {
    return 'Place(placeId: $placeId, name: $name, geo: $geo, categorySelections: $categorySelections, imageUrls: $imageUrls, location: $location, description: $description, validationConfig: $validationConfig, xp: $xp, contributionXp: $contributionXp, userId: $userId, rejectionReason: $rejectionReason, source: $source, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._geo, _geo) &&
            const DeepCollectionEquality()
                .equals(other._categorySelections, _categorySelections) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.validationConfig, validationConfig) ||
                other.validationConfig == validationConfig) &&
            (identical(other.xp, xp) || other.xp == xp) &&
            (identical(other.contributionXp, contributionXp) ||
                other.contributionXp == contributionXp) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      placeId,
      name,
      const DeepCollectionEquality().hash(_geo),
      const DeepCollectionEquality().hash(_categorySelections),
      const DeepCollectionEquality().hash(_imageUrls),
      location,
      description,
      validationConfig,
      xp,
      contributionXp,
      userId,
      rejectionReason,
      source,
      status,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      __$$PlaceImplCopyWithImpl<_$PlaceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceImplToJson(
      this,
    );
  }
}

abstract class _Place implements Place {
  const factory _Place(
      {required final String placeId,
      required final String name,
      required final Map<String, dynamic> geo,
      final List<CategorySelection> categorySelections,
      final List<String> imageUrls,
      final String? location,
      final String? description,
      final ValidationConfig? validationConfig,
      final int xp,
      final int contributionXp,
      final String? userId,
      final String? rejectionReason,
      final String source,
      final String status,
      @TimestampConverter() final Timestamp? createdAt,
      @TimestampConverter() final Timestamp? updatedAt}) = _$PlaceImpl;

  factory _Place.fromJson(Map<String, dynamic> json) = _$PlaceImpl.fromJson;

  @override
  String get placeId;
  @override
  String get name;
  @override
  Map<String, dynamic> get geo;
  @override
  List<CategorySelection> get categorySelections;
  @override
  List<String> get imageUrls;
  @override
  String? get location;
  @override
  String? get description;
  @override
  ValidationConfig? get validationConfig;
  @override
  int get xp;
  @override
  int get contributionXp;
  @override
  String? get userId;
  @override
  String? get rejectionReason;
  @override
  String get source;
  @override
  String get status;
  @override
  @TimestampConverter()
  Timestamp? get createdAt;
  @override
  @TimestampConverter()
  Timestamp? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$PlaceImplCopyWith<_$PlaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
