// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return _Category.fromJson(json);
}

/// @nodoc
mixin _$Category {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  String get interestName => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  bool get isVisibleInInterests => throw _privateConstructorUsedError;
  int get interestsOrder => throw _privateConstructorUsedError;
  int get placeOrder => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  List<String> get ancestorIds => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  Timestamp? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryCopyWith<Category> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) then) =
      _$CategoryCopyWithImpl<$Res, Category>;
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      String interestName,
      bool isActive,
      bool isVisibleInInterests,
      int interestsOrder,
      int placeOrder,
      int level,
      String? parentId,
      List<String> ancestorIds,
      @TimestampConverter() Timestamp? createdAt,
      @TimestampConverter() Timestamp? updatedAt});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res, $Val extends Category>
    implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? interestName = null,
    Object? isActive = null,
    Object? isVisibleInInterests = null,
    Object? interestsOrder = null,
    Object? placeOrder = null,
    Object? level = null,
    Object? parentId = freezed,
    Object? ancestorIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      interestName: null == interestName
          ? _value.interestName
          : interestName // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisibleInInterests: null == isVisibleInInterests
          ? _value.isVisibleInInterests
          : isVisibleInInterests // ignore: cast_nullable_to_non_nullable
              as bool,
      interestsOrder: null == interestsOrder
          ? _value.interestsOrder
          : interestsOrder // ignore: cast_nullable_to_non_nullable
              as int,
      placeOrder: null == placeOrder
          ? _value.placeOrder
          : placeOrder // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      ancestorIds: null == ancestorIds
          ? _value.ancestorIds
          : ancestorIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
}

/// @nodoc
abstract class _$$CategoryImplCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$$CategoryImplCopyWith(
          _$CategoryImpl value, $Res Function(_$CategoryImpl) then) =
      __$$CategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String icon,
      String interestName,
      bool isActive,
      bool isVisibleInInterests,
      int interestsOrder,
      int placeOrder,
      int level,
      String? parentId,
      List<String> ancestorIds,
      @TimestampConverter() Timestamp? createdAt,
      @TimestampConverter() Timestamp? updatedAt});
}

/// @nodoc
class __$$CategoryImplCopyWithImpl<$Res>
    extends _$CategoryCopyWithImpl<$Res, _$CategoryImpl>
    implements _$$CategoryImplCopyWith<$Res> {
  __$$CategoryImplCopyWithImpl(
      _$CategoryImpl _value, $Res Function(_$CategoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? icon = null,
    Object? interestName = null,
    Object? isActive = null,
    Object? isVisibleInInterests = null,
    Object? interestsOrder = null,
    Object? placeOrder = null,
    Object? level = null,
    Object? parentId = freezed,
    Object? ancestorIds = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$CategoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      interestName: null == interestName
          ? _value.interestName
          : interestName // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVisibleInInterests: null == isVisibleInInterests
          ? _value.isVisibleInInterests
          : isVisibleInInterests // ignore: cast_nullable_to_non_nullable
              as bool,
      interestsOrder: null == interestsOrder
          ? _value.interestsOrder
          : interestsOrder // ignore: cast_nullable_to_non_nullable
              as int,
      placeOrder: null == placeOrder
          ? _value.placeOrder
          : placeOrder // ignore: cast_nullable_to_non_nullable
              as int,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      ancestorIds: null == ancestorIds
          ? _value._ancestorIds
          : ancestorIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _$CategoryImpl implements _Category {
  const _$CategoryImpl(
      {required this.id,
      required this.name,
      this.icon = '',
      this.interestName = '',
      this.isActive = false,
      this.isVisibleInInterests = false,
      this.interestsOrder = 0,
      this.placeOrder = 0,
      this.level = 0,
      this.parentId,
      final List<String> ancestorIds = const [],
      @TimestampConverter() this.createdAt,
      @TimestampConverter() this.updatedAt})
      : _ancestorIds = ancestorIds;

  factory _$CategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final String interestName;
  @override
  @JsonKey()
  final bool isActive;
  @override
  @JsonKey()
  final bool isVisibleInInterests;
  @override
  @JsonKey()
  final int interestsOrder;
  @override
  @JsonKey()
  final int placeOrder;
  @override
  @JsonKey()
  final int level;
  @override
  final String? parentId;
  final List<String> _ancestorIds;
  @override
  @JsonKey()
  List<String> get ancestorIds {
    if (_ancestorIds is EqualUnmodifiableListView) return _ancestorIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ancestorIds);
  }

  @override
  @TimestampConverter()
  final Timestamp? createdAt;
  @override
  @TimestampConverter()
  final Timestamp? updatedAt;

  @override
  String toString() {
    return 'Category(id: $id, name: $name, icon: $icon, interestName: $interestName, isActive: $isActive, isVisibleInInterests: $isVisibleInInterests, interestsOrder: $interestsOrder, placeOrder: $placeOrder, level: $level, parentId: $parentId, ancestorIds: $ancestorIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.interestName, interestName) ||
                other.interestName == interestName) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVisibleInInterests, isVisibleInInterests) ||
                other.isVisibleInInterests == isVisibleInInterests) &&
            (identical(other.interestsOrder, interestsOrder) ||
                other.interestsOrder == interestsOrder) &&
            (identical(other.placeOrder, placeOrder) ||
                other.placeOrder == placeOrder) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality()
                .equals(other._ancestorIds, _ancestorIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      icon,
      interestName,
      isActive,
      isVisibleInInterests,
      interestsOrder,
      placeOrder,
      level,
      parentId,
      const DeepCollectionEquality().hash(_ancestorIds),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      __$$CategoryImplCopyWithImpl<_$CategoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryImplToJson(
      this,
    );
  }
}

abstract class _Category implements Category {
  const factory _Category(
      {required final String id,
      required final String name,
      final String icon,
      final String interestName,
      final bool isActive,
      final bool isVisibleInInterests,
      final int interestsOrder,
      final int placeOrder,
      final int level,
      final String? parentId,
      final List<String> ancestorIds,
      @TimestampConverter() final Timestamp? createdAt,
      @TimestampConverter() final Timestamp? updatedAt}) = _$CategoryImpl;

  factory _Category.fromJson(Map<String, dynamic> json) =
      _$CategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get icon;
  @override
  String get interestName;
  @override
  bool get isActive;
  @override
  bool get isVisibleInInterests;
  @override
  int get interestsOrder;
  @override
  int get placeOrder;
  @override
  int get level;
  @override
  String? get parentId;
  @override
  List<String> get ancestorIds;
  @override
  @TimestampConverter()
  Timestamp? get createdAt;
  @override
  @TimestampConverter()
  Timestamp? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$CategoryImplCopyWith<_$CategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
