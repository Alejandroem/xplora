import 'package:freezed_annotation/freezed_annotation.dart';

part 'xplora_profile.freezed.dart';
part 'xplora_profile.g.dart'; // Add this line

@freezed
abstract class XploraProfile with _$XploraProfile {
  const factory XploraProfile({
    required String? id,
    required String userId,
    required int level,
    required int experience,
    required List<String> categories,
    required String? avatarUrl,
    required String? username,
  }) = _XploraProfile;

  factory XploraProfile.fromJson(Map<String, dynamic> json) =>
      _$XploraProfileFromJson(json); // Add this method
}
