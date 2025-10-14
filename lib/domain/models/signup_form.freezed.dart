// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SignupForm _$SignupFormFromJson(Map<String, dynamic> json) {
  return _SignupForm.fromJson(json);
}

/// @nodoc
mixin _$SignupForm {
  String get email => throw _privateConstructorUsedError;
  bool get touchedEmail => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get touchedPassword => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;
  bool get touchedConfirmPassword => throw _privateConstructorUsedError;
  List<String> get errors => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SignupFormCopyWith<SignupForm> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupFormCopyWith<$Res> {
  factory $SignupFormCopyWith(
          SignupForm value, $Res Function(SignupForm) then) =
      _$SignupFormCopyWithImpl<$Res, SignupForm>;
  @useResult
  $Res call(
      {String email,
      bool touchedEmail,
      String password,
      bool touchedPassword,
      String confirmPassword,
      bool touchedConfirmPassword,
      List<String> errors,
      bool isLoading});
}

/// @nodoc
class _$SignupFormCopyWithImpl<$Res, $Val extends SignupForm>
    implements $SignupFormCopyWith<$Res> {
  _$SignupFormCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? touchedEmail = null,
    Object? password = null,
    Object? touchedPassword = null,
    Object? confirmPassword = null,
    Object? touchedConfirmPassword = null,
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
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      touchedConfirmPassword: null == touchedConfirmPassword
          ? _value.touchedConfirmPassword
          : touchedConfirmPassword // ignore: cast_nullable_to_non_nullable
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
abstract class _$$SignupFormImplCopyWith<$Res>
    implements $SignupFormCopyWith<$Res> {
  factory _$$SignupFormImplCopyWith(
          _$SignupFormImpl value, $Res Function(_$SignupFormImpl) then) =
      __$$SignupFormImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String email,
      bool touchedEmail,
      String password,
      bool touchedPassword,
      String confirmPassword,
      bool touchedConfirmPassword,
      List<String> errors,
      bool isLoading});
}

/// @nodoc
class __$$SignupFormImplCopyWithImpl<$Res>
    extends _$SignupFormCopyWithImpl<$Res, _$SignupFormImpl>
    implements _$$SignupFormImplCopyWith<$Res> {
  __$$SignupFormImplCopyWithImpl(
      _$SignupFormImpl _value, $Res Function(_$SignupFormImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? touchedEmail = null,
    Object? password = null,
    Object? touchedPassword = null,
    Object? confirmPassword = null,
    Object? touchedConfirmPassword = null,
    Object? errors = null,
    Object? isLoading = null,
  }) {
    return _then(_$SignupFormImpl(
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
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      touchedConfirmPassword: null == touchedConfirmPassword
          ? _value.touchedConfirmPassword
          : touchedConfirmPassword // ignore: cast_nullable_to_non_nullable
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
class _$SignupFormImpl implements _SignupForm {
  const _$SignupFormImpl(
      {required this.email,
      required this.touchedEmail,
      required this.password,
      required this.touchedPassword,
      required this.confirmPassword,
      required this.touchedConfirmPassword,
      required final List<String> errors,
      required this.isLoading})
      : _errors = errors;

  factory _$SignupFormImpl.fromJson(Map<String, dynamic> json) =>
      _$$SignupFormImplFromJson(json);

  @override
  final String email;
  @override
  final bool touchedEmail;
  @override
  final String password;
  @override
  final bool touchedPassword;
  @override
  final String confirmPassword;
  @override
  final bool touchedConfirmPassword;
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
    return 'SignupForm(email: $email, touchedEmail: $touchedEmail, password: $password, touchedPassword: $touchedPassword, confirmPassword: $confirmPassword, touchedConfirmPassword: $touchedConfirmPassword, errors: $errors, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupFormImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.touchedEmail, touchedEmail) ||
                other.touchedEmail == touchedEmail) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.touchedPassword, touchedPassword) ||
                other.touchedPassword == touchedPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.touchedConfirmPassword, touchedConfirmPassword) ||
                other.touchedConfirmPassword == touchedConfirmPassword) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      touchedEmail,
      password,
      touchedPassword,
      confirmPassword,
      touchedConfirmPassword,
      const DeepCollectionEquality().hash(_errors),
      isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupFormImplCopyWith<_$SignupFormImpl> get copyWith =>
      __$$SignupFormImplCopyWithImpl<_$SignupFormImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SignupFormImplToJson(
      this,
    );
  }
}

abstract class _SignupForm implements SignupForm {
  const factory _SignupForm(
      {required final String email,
      required final bool touchedEmail,
      required final String password,
      required final bool touchedPassword,
      required final String confirmPassword,
      required final bool touchedConfirmPassword,
      required final List<String> errors,
      required final bool isLoading}) = _$SignupFormImpl;

  factory _SignupForm.fromJson(Map<String, dynamic> json) =
      _$SignupFormImpl.fromJson;

  @override
  String get email;
  @override
  bool get touchedEmail;
  @override
  String get password;
  @override
  bool get touchedPassword;
  @override
  String get confirmPassword;
  @override
  bool get touchedConfirmPassword;
  @override
  List<String> get errors;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$SignupFormImplCopyWith<_$SignupFormImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
