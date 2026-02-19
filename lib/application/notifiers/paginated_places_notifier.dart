import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/place.dart';
import '../../domain/services/place_crud_service.dart';

class PaginatedPlacesState {
  final List<Place> places;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const PaginatedPlacesState({
    this.places = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  PaginatedPlacesState copyWith({
    List<Place>? places,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return PaginatedPlacesState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class PaginatedPlacesNotifier extends StateNotifier<PaginatedPlacesState> {
  final PlaceCrudService _placeCrudService;
  static const int _initialPageSize = 6;
  static const int _pageSize = 6;
  Place? _lastDocument;

  static const List<Map<String, dynamic>> _activeFilter = [
    {'field': 'status', 'operator': '==', 'value': 'active'},
  ];

  PaginatedPlacesNotifier(this._placeCrudService)
      : super(const PaginatedPlacesState());

  Future<void> loadInitial() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final places = await _placeCrudService.readPaginated(
        limit: _initialPageSize,
        startAfter: null,
        filters: _activeFilter,
      );

      if (places == null || places.isEmpty) {
        state = state.copyWith(
          places: [],
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      _lastDocument = places.last;

      // If odd count, load one more to keep the grid even
      List<Place> finalPlaces = places;
      if (places.length > _initialPageSize && places.length % 2 == 1) {
        final oneMore = await _placeCrudService.readPaginated(
          limit: 1,
          startAfter: _lastDocument,
          filters: _activeFilter,
        );

        if (oneMore != null && oneMore.isNotEmpty) {
          _lastDocument = oneMore.last;
          finalPlaces = [...places, ...oneMore];
        }
      }

      final hasMore = places.length >= _initialPageSize;

      state = state.copyWith(
        places: finalPlaces,
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final places = await _placeCrudService.readPaginated(
        limit: _pageSize,
        startAfter: _lastDocument,
        filters: _activeFilter,
      );

      if (places == null || places.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      _lastDocument = places.last;
      final hasMore = places.length >= _pageSize;

      state = state.copyWith(
        places: [...state.places, ...places],
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    _lastDocument = null;
    state = const PaginatedPlacesState();
  }
}
