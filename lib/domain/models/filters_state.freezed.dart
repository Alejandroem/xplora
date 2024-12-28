// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filters_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FiltersState _$FiltersStateFromJson(Map<String, dynamic> json) {
  return _FiltersState.fromJson(json);
}

/// @nodoc
mixin _$FiltersState {
  String get selectedType => throw _privateConstructorUsedError;
  int get minimumDistance => throw _privateConstructorUsedError;
  bool get filtersEnabled => throw _privateConstructorUsedError;

  /// Serializes this FiltersState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FiltersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FiltersStateCopyWith<FiltersState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FiltersStateCopyWith<$Res> {
  factory $FiltersStateCopyWith(
          FiltersState value, $Res Function(FiltersState) then) =
      _$FiltersStateCopyWithImpl<$Res, FiltersState>;
  @useResult
  $Res call({String selectedType, int minimumDistance, bool filtersEnabled});
}

/// @nodoc
class _$FiltersStateCopyWithImpl<$Res, $Val extends FiltersState>
    implements $FiltersStateCopyWith<$Res> {
  _$FiltersStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FiltersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedType = null,
    Object? minimumDistance = null,
    Object? filtersEnabled = null,
  }) {
    return _then(_value.copyWith(
      selectedType: null == selectedType
          ? _value.selectedType
          : selectedType // ignore: cast_nullable_to_non_nullable
              as String,
      minimumDistance: null == minimumDistance
          ? _value.minimumDistance
          : minimumDistance // ignore: cast_nullable_to_non_nullable
              as int,
      filtersEnabled: null == filtersEnabled
          ? _value.filtersEnabled
          : filtersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FiltersStateImplCopyWith<$Res>
    implements $FiltersStateCopyWith<$Res> {
  factory _$$FiltersStateImplCopyWith(
          _$FiltersStateImpl value, $Res Function(_$FiltersStateImpl) then) =
      __$$FiltersStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedType, int minimumDistance, bool filtersEnabled});
}

/// @nodoc
class __$$FiltersStateImplCopyWithImpl<$Res>
    extends _$FiltersStateCopyWithImpl<$Res, _$FiltersStateImpl>
    implements _$$FiltersStateImplCopyWith<$Res> {
  __$$FiltersStateImplCopyWithImpl(
      _$FiltersStateImpl _value, $Res Function(_$FiltersStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FiltersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedType = null,
    Object? minimumDistance = null,
    Object? filtersEnabled = null,
  }) {
    return _then(_$FiltersStateImpl(
      selectedType: null == selectedType
          ? _value.selectedType
          : selectedType // ignore: cast_nullable_to_non_nullable
              as String,
      minimumDistance: null == minimumDistance
          ? _value.minimumDistance
          : minimumDistance // ignore: cast_nullable_to_non_nullable
              as int,
      filtersEnabled: null == filtersEnabled
          ? _value.filtersEnabled
          : filtersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FiltersStateImpl implements _FiltersState {
  const _$FiltersStateImpl(
      {this.selectedType = 'All',
      this.minimumDistance = 500000,
      this.filtersEnabled = false});

  factory _$FiltersStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FiltersStateImplFromJson(json);

  @override
  @JsonKey()
  final String selectedType;
  @override
  @JsonKey()
  final int minimumDistance;
  @override
  @JsonKey()
  final bool filtersEnabled;

  @override
  String toString() {
    return 'FiltersState(selectedType: $selectedType, minimumDistance: $minimumDistance, filtersEnabled: $filtersEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FiltersStateImpl &&
            (identical(other.selectedType, selectedType) ||
                other.selectedType == selectedType) &&
            (identical(other.minimumDistance, minimumDistance) ||
                other.minimumDistance == minimumDistance) &&
            (identical(other.filtersEnabled, filtersEnabled) ||
                other.filtersEnabled == filtersEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, selectedType, minimumDistance, filtersEnabled);

  /// Create a copy of FiltersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FiltersStateImplCopyWith<_$FiltersStateImpl> get copyWith =>
      __$$FiltersStateImplCopyWithImpl<_$FiltersStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FiltersStateImplToJson(
      this,
    );
  }
}

abstract class _FiltersState implements FiltersState {
  const factory _FiltersState(
      {final String selectedType,
      final int minimumDistance,
      final bool filtersEnabled}) = _$FiltersStateImpl;

  factory _FiltersState.fromJson(Map<String, dynamic> json) =
      _$FiltersStateImpl.fromJson;

  @override
  String get selectedType;
  @override
  int get minimumDistance;
  @override
  bool get filtersEnabled;

  /// Create a copy of FiltersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FiltersStateImplCopyWith<_$FiltersStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
