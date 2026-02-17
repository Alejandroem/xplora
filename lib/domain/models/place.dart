import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

@freezed
class Place with _$Place {
  const factory Place({
    required String? placeId,
    required String name,
    required Map<String, double> geo,
    required String geohash,
    required List<String> categories,
    @Default([]) List<String> imageUrls,
    String? address,
    @Default('seed') String source,
    @Default('active') String status,
    @TimestampConverter() Timestamp? createdAt,
    @TimestampConverter() Timestamp? updatedAt,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}

/// Converter for Firestore Timestamp to handle JSON serialization
class TimestampConverter implements JsonConverter<Timestamp?, Object?> {
  const TimestampConverter();

  @override
  Timestamp? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json;
    if (json is String) {
      // Backward compatibility: parse ISO string to Timestamp
      try {
        final dateTime = DateTime.parse(json);
        return Timestamp.fromDate(dateTime);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  @override
  Object? toJson(Timestamp? timestamp) {
    return timestamp; // Return Timestamp as-is for Firestore
  }
}
