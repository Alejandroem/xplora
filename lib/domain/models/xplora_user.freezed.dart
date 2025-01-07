// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'xplora_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

XploraUser _$XploraUserFromJson(Map<String, dynamic> json) {
  return _XploraUser.fromJson(json);
}

/// @nodoc
mixin _$XploraUser {
  String? get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;

  /// Serializes this XploraUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of XploraUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $XploraUserCopyWith<XploraUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XploraUserCopyWith<$Res> {
  factory $XploraUserCopyWith(
          XploraUser value, $Res Function(XploraUser) then) =
      _$XploraUserCopyWithImpl<$Res, XploraUser>;
  @useResult
  $Res call(
      {String? id,
      String name,
      String email,
      String username,
      bool isEmailVerified});
}

/// @nodoc
class _$XploraUserCopyWithImpl<$Res, $Val extends XploraUser>
    implements $XploraUserCopyWith<$Res> {
  _$XploraUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of XploraUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? username = null,
    Object? isEmailVerified = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$XploraUserImplCopyWith<$Res>
    implements $XploraUserCopyWith<$Res> {
  factory _$$XploraUserImplCopyWith(
          _$XploraUserImpl value, $Res Function(_$XploraUserImpl) then) =
      __$$XploraUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      String email,
      String username,
      bool isEmailVerified});
}

/// @nodoc
class __$$XploraUserImplCopyWithImpl<$Res>
    extends _$XploraUserCopyWithImpl<$Res, _$XploraUserImpl>
    implements _$$XploraUserImplCopyWith<$Res> {
  __$$XploraUserImplCopyWithImpl(
      _$XploraUserImpl _value, $Res Function(_$XploraUserImpl) _then)
      : super(_value, _then);

  /// Create a copy of XploraUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? username = null,
    Object? isEmailVerified = null,
  }) {
    return _then(_$XploraUserImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$XploraUserImpl implements _XploraUser {
  const _$XploraUserImpl(
      {required this.id,
      required this.name,
      required this.email,
      required this.username,
      required this.isEmailVerified});

  factory _$XploraUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$XploraUserImplFromJson(json);

  @override
  final String? id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String username;
  @override
  final bool isEmailVerified;

  @override
  String toString() {
    return 'XploraUser(id: $id, name: $name, email: $email, username: $username, isEmailVerified: $isEmailVerified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XploraUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, email, username, isEmailVerified);

  /// Create a copy of XploraUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$XploraUserImplCopyWith<_$XploraUserImpl> get copyWith =>
      __$$XploraUserImplCopyWithImpl<_$XploraUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$XploraUserImplToJson(
      this,
    );
  }
}

abstract class _XploraUser implements XploraUser {
  const factory _XploraUser(
      {required final String? id,
      required final String name,
      required final String email,
      required final String username,
      required final bool isEmailVerified}) = _$XploraUserImpl;

  factory _XploraUser.fromJson(Map<String, dynamic> json) =
      _$XploraUserImpl.fromJson;

  @override
  String? get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get username;
  @override
  bool get isEmailVerified;

  /// Create a copy of XploraUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$XploraUserImplCopyWith<_$XploraUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
