import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

import '../../application/providers/place_providers.dart';
import '../../application/providers/storage_providers.dart';
import '../../domain/models/category.dart';
import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';
import '../../domain/services/storage_service.dart';

// ── Selected Location ─────────────────────────────────────────────────────────

class SelectedLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeName;

  SelectedLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  String get displayText {
    if (placeName != null && placeName!.isNotEmpty) return placeName!;
    if (address != null && address!.isNotEmpty) return address!;
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
}

// ── Image selection ───────────────────────────────────────────────────────────

class SelectedImagesNotifier extends StateNotifier<List<String>> {
  SelectedImagesNotifier() : super([]);

  static const int maxImages = 4;

  bool get canAddMore => state.length < maxImages;

  void add(String path) {
    if (!canAddMore) return;
    state = [...state, path];
  }

  void remove(int index) {
    final updated = [...state]..removeAt(index);
    state = updated;
  }
}

final selectedPlaceImagesProvider =
    StateNotifierProvider.autoDispose<SelectedImagesNotifier, List<String>>(
  (ref) => SelectedImagesNotifier(),
);

// ── Form field providers ───────────────────────────────────────────────────────

final categorySelectionsProvider =
    StateProvider.autoDispose<Map<String, String?>>((ref) => {});

final selectedLocationProvider =
    StateProvider.autoDispose<SelectedLocation?>((ref) => null);

// ── Place submission ──────────────────────────────────────────────────────────

class PlaceSubmissionState {
  final bool isLoading;
  final String? error;

  const PlaceSubmissionState({this.isLoading = false, this.error});
}

class PlaceSubmissionNotifier extends StateNotifier<PlaceSubmissionState> {
  final StorageService _storageService;
  final PlaceCrudService _placeCrudService;

  PlaceSubmissionNotifier(this._storageService, this._placeCrudService)
      : super(const PlaceSubmissionState());

  Future<void> submit({
    required String name,
    required String description,
    required SelectedLocation location,
    required List<String> imagePaths,
    required Map<String, String?> categorySelections,
    required List<Category> categories,
  }) async {
    state = const PlaceSubmissionState(isLoading: true);

    try {
      // 1. Pre-generate Firestore doc ID so images can be stored under it
      final placeId = _placeCrudService.generateId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // 2. Upload images to places/{placeId}/ folder
      final imageUrls = <String>[];
      for (var i = 0; i < imagePaths.length; i++) {
        final url = await _storageService.uploadImage(
          imagePaths[i],
          'places/$placeId/${timestamp}_$i',
        );
        imageUrls.add(url);
      }

      // 3. Reverse geocode → "City, PK" format
      String? locationString;
      try {
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          locationString = [p.locality, p.isoCountryCode]
              .where((s) => s != null && s.isNotEmpty)
              .join(', ');
        }
      } catch (_) {
        locationString = location.address;
      }

      // 4. Build CategorySelection list from the selections map
      final categorySelectionList = categorySelections.entries
          .where((e) => e.value != null)
          .map((e) {
            final child = categories.firstWhere((c) => c.id == e.value);
            return CategorySelection(
              selectedId: child.id,
              path: [...child.ancestorIds, child.id],
            );
          })
          .toList();

      // 5. Build and save Place using the pre-generated ID
      final now = Timestamp.now();
      final place = Place(
        placeId: placeId,
        name: name,
        description: description,
        geo: {'lat': location.latitude, 'lng': location.longitude},
        geohash: '',
        location: locationString,
        imageUrls: imageUrls,
        categorySelections: categorySelectionList,
        xp: 0,
        source: 'user_contribution',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      await _placeCrudService.updateOrCreate(place, placeId);

      state = const PlaceSubmissionState();
    } catch (e) {
      print(e);
      state = PlaceSubmissionState(error: e.toString());
    }
  }
}

final placeSubmissionProvider = StateNotifierProvider.autoDispose<
    PlaceSubmissionNotifier, PlaceSubmissionState>(
  (ref) => PlaceSubmissionNotifier(
    ref.read(storageServiceProvider),
    ref.read(placeCrudServiceProvider),
  ),
);
