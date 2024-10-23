// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LoginForm _$LoginFormFromJson(Map<String, dynamic> json) {
  return _LoginForm.fromJson(json);
}

/// @nodoc
mixin _$LoginForm {
  String get email => throw _privateConstructorUsedError;
  bool get touchedEmail => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get touchedPassword => throw _privateConstructorUsedError;
  bool get obscureText => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  /// Serializes this LoginForm to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginFormCopyWith<LoginForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginFormCopyWith<$Res> {
  factory $LoginFormCopyWith(LoginForm value, $Res Function(LoginForm) then) =
      _$LoginFormCopyWithImpl<$Res, LoginForm>;
  @useResult
  $Res call(
      {String email,
      bool touchedEmail,
      String password,
      bool touchedPassword,
      bool obscureText,
      List<String> errors,
      bool isLoading});
}

/// @nodoc
class _$LoginFormCopyWithImpl<$Res, $Val extends LoginForm>
    implements $LoginFormCopyWith<$Res> {
  _$LoginFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? touchedEmail = null,
    Object? password = null,
    Object? touchedPassword = null,
    Object? obscureText = null,
    Object? errors = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      touchedEmail: null == touchedEmail
          ? _value.touchedEmail
          : touchedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      touchedPassword: null == touchedPassword
          ? _value.touchedPassword
          : touchedPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      obscureText: null == obscureText
          ? _value.obscureText
          : obscureText // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginFormImplCopyWith<$Res>
    implements $LoginFormCopyWith<$Res> {
  factory _$$LoginFormImplCopyWith(
          _$LoginFormImpl value, $Res Function(_$LoginFormImpl) then) =
      __$$LoginFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      bool touchedEmail,
      String password,
      bool touchedPassword,
      bool obscureText,
      List<String> errors,
      bool isLoading});
}

/// @nodoc
class __$$LoginFormImplCopyWithImpl<$Res>
    extends _$LoginFormCopyWithImpl<$Res, _$LoginFormImpl>
    implements _$$LoginFormImplCopyWith<$Res> {
  __$$LoginFormImplCopyWithImpl(
      _$LoginFormImpl _value, $Res Function(_$LoginFormImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? touchedEmail = null,
    Object? password = null,
    Object? touchedPassword = null,
    Object? obscureText = null,
    Object? errors = null,
    Object? isLoading = null,
  }) {
    return _then(_$LoginFormImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      touchedEmail: null == touchedEmail
          ? _value.touchedEmail
          : touchedEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      touchedPassword: null == touchedPassword
          ? _value.touchedPassword
          : touchedPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      obscureText: null == obscureText
          ? _value.obscureText
          : obscureText // ignore: cast_nullable_to_non_nullable
              as bool,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginFormImpl implements _LoginForm {
  const _$LoginFormImpl(
      {required this.email,
      required this.touchedEmail,
      required this.password,
      required this.touchedPassword,
      required this.obscureText,
      required final List<String> errors,
      required this.isLoading})
      : _errors = errors;

  factory _$LoginFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginFormImplFromJson(json);

  @override
  final String email;
  @override
  final bool touchedEmail;
  @override
  final String password;
  @override
  final bool touchedPassword;
  @override
  final bool obscureText;
  final List<String> _errors;
  @override
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  @override
  final bool isLoading;

  @override
  String toString() {
    return 'LoginForm(email: $email, touchedEmail: $touchedEmail, password: $password, touchedPassword: $touchedPassword, obscureText: $obscureText, errors: $errors, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginFormImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.touchedEmail, touchedEmail) ||
                other.touchedEmail == touchedEmail) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.touchedPassword, touchedPassword) ||
                other.touchedPassword == touchedPassword) &&
            (identical(other.obscureText, obscureText) ||
                other.obscureText == obscureText) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      touchedEmail,
      password,
      touchedPassword,
      obscureText,
      const DeepCollectionEquality().hash(_errors),
      isLoading);

  /// Create a copy of LoginForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginFormImplCopyWith<_$LoginFormImpl> get copyWith =>
      __$$LoginFormImplCopyWithImpl<_$LoginFormImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginFormImplToJson(
      this,
    );
  }
}

abstract class _LoginForm implements LoginForm {
  const factory _LoginForm(
      {required final String email,
      required final bool touchedEmail,
      required final String password,
      required final bool touchedPassword,
      required final bool obscureText,
      required final List<String> errors,
      required final bool isLoading}) = _$LoginFormImpl;

  factory _LoginForm.fromJson(Map<String, dynamic> json) =
      _$LoginFormImpl.fromJson;

  @override
  String get email;
  @override
  bool get touchedEmail;
  @override
  String get password;
  @override
  bool get touchedPassword;
  @override
  bool get obscureText;
  @override
  List<String> get errors;
  @override
  bool get isLoading;

  /// Create a copy of LoginForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginFormImplCopyWith<_$LoginFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
