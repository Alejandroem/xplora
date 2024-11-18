// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xplora_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

XploraProfile _$XploraProfileFromJson(Map<String, dynamic> json) {
  return _XploraProfile.fromJson(json);
}

/// @nodoc
mixin _$XploraProfile {
  String? get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  int get experience => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;

  /// Serializes this XploraProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of XploraProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $XploraProfileCopyWith<XploraProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XploraProfileCopyWith<$Res> {
  factory $XploraProfileCopyWith(
          XploraProfile value, $Res Function(XploraProfile) then) =
      _$XploraProfileCopyWithImpl<$Res, XploraProfile>;
  @useResult
  $Res call(
      {String? id,
      String userId,
      int level,
      int experience,
      List<String> categories,
      String? avatarUrl,
      String? username});
}

/// @nodoc
class _$XploraProfileCopyWithImpl<$Res, $Val extends XploraProfile>
    implements $XploraProfileCopyWith<$Res> {
  _$XploraProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of XploraProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? level = null,
    Object? experience = null,
    Object? categories = null,
    Object? avatarUrl = freezed,
    Object? username = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$XploraProfileImplCopyWith<$Res>
    implements $XploraProfileCopyWith<$Res> {
  factory _$$XploraProfileImplCopyWith(
          _$XploraProfileImpl value, $Res Function(_$XploraProfileImpl) then) =
      __$$XploraProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String userId,
      int level,
      int experience,
      List<String> categories,
      String? avatarUrl,
      String? username});
}

/// @nodoc
class __$$XploraProfileImplCopyWithImpl<$Res>
    extends _$XploraProfileCopyWithImpl<$Res, _$XploraProfileImpl>
    implements _$$XploraProfileImplCopyWith<$Res> {
  __$$XploraProfileImplCopyWithImpl(
      _$XploraProfileImpl _value, $Res Function(_$XploraProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of XploraProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = null,
    Object? level = null,
    Object? experience = null,
    Object? categories = null,
    Object? avatarUrl = freezed,
    Object? username = freezed,
  }) {
    return _then(_$XploraProfileImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as int,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$XploraProfileImpl implements _XploraProfile {
  const _$XploraProfileImpl(
      {required this.id,
      required this.userId,
      required this.level,
      required this.experience,
      required final List<String> categories,
      required this.avatarUrl,
      required this.username})
      : _categories = categories;

  factory _$XploraProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$XploraProfileImplFromJson(json);

  @override
  final String? id;
  @override
  final String userId;
  @override
  final int level;
  @override
  final int experience;
  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? avatarUrl;
  @override
  final String? username;

  @override
  String toString() {
    return 'XploraProfile(id: $id, userId: $userId, level: $level, experience: $experience, categories: $categories, avatarUrl: $avatarUrl, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XploraProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, level, experience,
      const DeepCollectionEquality().hash(_categories), avatarUrl, username);

  /// Create a copy of XploraProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$XploraProfileImplCopyWith<_$XploraProfileImpl> get copyWith =>
      __$$XploraProfileImplCopyWithImpl<_$XploraProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$XploraProfileImplToJson(
      this,
    );
  }
}

abstract class _XploraProfile implements XploraProfile {
  const factory _XploraProfile(
      {required final String? id,
      required final String userId,
      required final int level,
      required final int experience,
      required final List<String> categories,
      required final String? avatarUrl,
      required final String? username}) = _$XploraProfileImpl;

  factory _XploraProfile.fromJson(Map<String, dynamic> json) =
      _$XploraProfileImpl.fromJson;

  @override
  String? get id;
  @override
  String get userId;
  @override
  int get level;
  @override
  int get experience;
  @override
  List<String> get categories;
  @override
  String? get avatarUrl;
  @override
  String? get username;

  /// Create a copy of XploraProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$XploraProfileImplCopyWith<_$XploraProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
