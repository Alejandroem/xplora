import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/place_providers.dart';
import '../../application/providers/storage_providers.dart';
import '../../domain/models/place.dart';
import '../../domain/services/auth_service.dart';
import '../../domain/services/place_crud_service.dart';
import '../../domain/services/storage_service.dart';

// ── Selected location ────────────────────────────────────────────────────────

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

final selectedLocationProvider =
    StateProvider.autoDispose<SelectedLocation?>((ref) => null);

// ── Selected images ───────────────────────────────────────────────────────────

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

// ── Category selections ───────────────────────────────────────────────────────

/// Map of parentCategoryId → selected childCategoryId.
final categorySelectionsProvider =
    StateProvider.autoDispose<Map<String, String?>>((ref) => {});

// ── Place submission ──────────────────────────────────────────────────────────

class PlaceSubmissionState {
  final bool isLoading;
  final String? error;
  final double progress;
  final String statusMessage;

  const PlaceSubmissionState({
    this.isLoading = false,
    this.error,
    this.progress = 0.0,
    this.statusMessage = '',
  });
}

class PlaceSubmissionNotifier extends StateNotifier<PlaceSubmissionState> {
  final Ref _ref;
  final StorageService _storageService;
  final PlaceCrudService _placeCrudService;
  final AuthService _authService;

  PlaceSubmissionNotifier(
      this._ref, this._storageService, this._placeCrudService, this._authService)
      : super(const PlaceSubmissionState());

  bool validate() {
    if (_ref.read(selectedPlaceImagesProvider).isEmpty) {
      state = const PlaceSubmissionState(error: 'Please add at least one image');
      return false;
    }
    if (_ref.read(selectedLocationProvider) == null) {
      state = const PlaceSubmissionState(error: 'Please select a location');
      return false;
    }
    if (!_ref.read(categorySelectionsProvider).values.any((v) => v != null)) {
      state = const PlaceSubmissionState(error: 'Please select at least one category');
      return false;
    }
    return true;
  }

  Future<void> submit({
    required String name,
    required String description,
  }) async {
    if (!validate()) return;

    try {
      final imagePaths = _ref.read(selectedPlaceImagesProvider);
      final location = _ref.read(selectedLocationProvider)!;
      final categorySelections = _ref.read(categorySelectionsProvider);
      final categories = await _ref.read(placeCategoriesProvider.future);

      final total = imagePaths.length + 2; // images + geocoding + saving

      // 1. Pre-generate Firestore doc ID so images can be stored under it
      final placeId = _placeCrudService.generateId();
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // 2. Upload images to places/{placeId}/ folder
      final imageUrls = <String>[];
      for (var i = 0; i < imagePaths.length; i++) {
        state = PlaceSubmissionState(
          isLoading: true,
          progress: i / total,
          statusMessage: 'Uploading image ${i + 1} of ${imagePaths.length}...',
        );
        final url = await _storageService.uploadImage(
          imagePaths[i],
          'places/$placeId/${timestamp}_$i',
        );
        imageUrls.add(url);
      }

      // 3. Reverse geocode → "City, PK" format
      state = PlaceSubmissionState(
        isLoading: true,
        progress: imagePaths.length / total,
        statusMessage: 'Getting location...',
      );
      String? locationString;
      try {
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          // locality is the city name; fall back to sub-area then state
          final city = [p.locality, p.subAdministrativeArea, p.administrativeArea]
              .firstWhere((s) => s != null && s.isNotEmpty, orElse: () => null);
          final country = p.isoCountryCode;
          if (city != null && country != null && country.isNotEmpty) {
            locationString = '$city, $country';
          } else {
            locationString = location.address;
            print('locationString from address b/c city,country format not available: $locationString');
          }
        } else {
          locationString = location.address;
          print('locationString from address b/c placemarks are empty: $locationString');
        }
      } catch (_) {
        locationString = location.address;
        print('locationString from address b/c placemark throw error: $locationString');
      }

      // throw Exception('error');

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
      state = PlaceSubmissionState(
        isLoading: true,
        progress: (imagePaths.length + 1) / total,
        statusMessage: 'Saving place...',
      );
      final userId = (await _authService.getAuthUser())?.id;
      final now = Timestamp.now();
      final place = Place(
        placeId: placeId,
        name: name,
        description: description,
        geo: GeoFirePoint(GeoPoint(location.latitude, location.longitude)).data,
        location: locationString,
        imageUrls: imageUrls,
        categorySelections: categorySelectionList,
        xp: 0,
        userId: userId,
        source: 'user_contribution',
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      await _placeCrudService.updateOrCreate(place, placeId);

      state = const PlaceSubmissionState();
    } catch (e) {
      print('Error in submit: $e');
      state = PlaceSubmissionState(error: e.toString());
    }
  }
}

final placeSubmissionProvider = StateNotifierProvider.autoDispose<
    PlaceSubmissionNotifier, PlaceSubmissionState>(
  (ref) => PlaceSubmissionNotifier(
    ref,
    ref.read(storageServiceProvider),
    ref.read(placeCrudServiceProvider),
    ref.read(authServiceProvider),
  ),
);
