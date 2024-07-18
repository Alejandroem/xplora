import 'package:freezed_annotation/freezed_annotation.dart';

part 'xplora_profile.freezed.dart';
part 'xplora_profile.g.dart'; // Add this line

@freezed
abstract class XploraProfile with _$XploraProfile {
  const factory XploraProfile({
    required List<String> categories,
  }) = _XploraProfile;

  factory XploraProfile.fromJson(Map<String, dynamic> json) =>
      _$XploraProfileFromJson(json); // Add this method
}