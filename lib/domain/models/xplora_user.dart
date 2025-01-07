import 'package:freezed_annotation/freezed_annotation.dart';

part 'xplora_user.freezed.dart';
part 'xplora_user.g.dart';

@freezed
abstract class XploraUser with _$XploraUser {
  const factory XploraUser({
    required String? id,
    required String name,
    required String email,
    required String username,
    required bool isEmailVerified,
  }) = _XploraUser;

  factory XploraUser.fromJson(Map<String, dynamic> json) =>
      _$XploraUserFromJson(json);
}
