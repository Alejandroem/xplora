import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form.freezed.dart';
part 'login_form.g.dart';

@freezed
abstract class LoginForm with _$LoginForm {
  const factory LoginForm({
    required String email,
    required bool touchedEmail,
    required String password,
    required bool touchedPassword,
    required bool obscureText,
    required List<String> errors,
    required bool isLoading,
    @Default(false) bool needsProfileCompletion,
  }) = _LoginForm;

  factory LoginForm.fromJson(Map<String, dynamic> json) =>
      _$LoginFormFromJson(json);
}
