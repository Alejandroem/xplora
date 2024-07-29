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
  int get level => throw _privateConstructorUsedError;
  int get experience => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $XploraProfileCopyWith<XploraProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XploraProfileCopyWith<$Res> {
  factory $XploraProfileCopyWith(
          XploraProfile value, $Res Function(XploraProfile) then) =
      _$XploraProfileCopyWithImpl<$Res, XploraProfile>;
  @useResult
  $Res call({int level, int experience, List<String> categories});
}

/// @nodoc
class _$XploraProfileCopyWithImpl<$Res, $Val extends XploraProfile>
    implements $XploraProfileCopyWith<$Res> {
  _$XploraProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? experience = null,
    Object? categories = null,
  }) {
    return _then(_value.copyWith(
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
  $Res call({int level, int experience, List<String> categories});
}

/// @nodoc
class __$$XploraProfileImplCopyWithImpl<$Res>
    extends _$XploraProfileCopyWithImpl<$Res, _$XploraProfileImpl>
    implements _$$XploraProfileImplCopyWith<$Res> {
  __$$XploraProfileImplCopyWithImpl(
      _$XploraProfileImpl _value, $Res Function(_$XploraProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? experience = null,
    Object? categories = null,
  }) {
    return _then(_$XploraProfileImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$XploraProfileImpl implements _XploraProfile {
  const _$XploraProfileImpl(
      {required this.level,
      required this.experience,
      required final List<String> categories})
      : _categories = categories;

  factory _$XploraProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$XploraProfileImplFromJson(json);

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
  String toString() {
    return 'XploraProfile(level: $level, experience: $experience, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XploraProfileImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, level, experience,
      const DeepCollectionEquality().hash(_categories));

  @JsonKey(ignore: true)
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
      {required final int level,
      required final int experience,
      required final List<String> categories}) = _$XploraProfileImpl;

  factory _XploraProfile.fromJson(Map<String, dynamic> json) =
      _$XploraProfileImpl.fromJson;

  @override
  int get level;
  @override
  int get experience;
  @override
  List<String> get categories;
  @override
  @JsonKey(ignore: true)
  _$$XploraProfileImplCopyWith<_$XploraProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
