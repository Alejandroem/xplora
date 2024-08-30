import 'package:freezed_annotation/freezed_annotation.dart';

part 'adventure.freezed.dart';
part 'adventure.g.dart';

@freezed
class Adventure with _$Adventure {
  const factory Adventure({
    required String? id,
    required String? userId, //Only set if a user already got through it
    required String title,
    required String shortDescription,
    required String longDescription,
    required String imageUrl,
    required double experience,
    required double latitude,
    required double longitude,
  }) = _Adventure;

  factory Adventure.fromJson(Map<String, dynamic> json) =>
      _$AdventureFromJson(json);

  factory Adventure.demo() => const Adventure(
        id: '1',
        userId: '1',
        title: 'The Great Adventure',
        shortDescription: 'A short description',
        longDescription: 'A long description',
        imageUrl: 'https://placehold.co/600x400.png',
        experience: 100,
        latitude: 0,
        longitude: 0,
      );
}
