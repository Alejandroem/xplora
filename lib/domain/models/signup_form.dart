import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_form.freezed.dart';
part 'signup_form.g.dart';

@freezed
abstract class SignupForm with _$SignupForm {
  const factory SignupForm({
    required String username,
    required bool touchedUsername,
    required String email,
    required bool touchedEmail,
    required String password,
    required bool touchedPassword,
    required String confirmPassword,
    required bool touchedConfirmPassword,
    required String firstName,
    required bool touchedFirstName,
    required String lastName,
    required bool touchedLastName,
    required List<String> errors,
    required bool isLoading,
    required bool isUsernameUnique,
  }) = _SignupForm;

  factory SignupForm.fromJson(Map<String, dynamic> json) =>
      _$SignupFormFromJson(json);
}
