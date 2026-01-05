import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';
import '../../domain/services/adventure_crud_service.dart';

class PaginatedAdventuresState {
  final List<Adventure> adventures;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  const PaginatedAdventuresState({
    this.adventures = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  PaginatedAdventuresState copyWith({
    List<Adventure>? adventures,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return PaginatedAdventuresState(
      adventures: adventures ?? this.adventures,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class PaginatedAdventuresNotifier
    extends StateNotifier<PaginatedAdventuresState> {
  final AdventureCrudService _adventureCrudService;
  static const int _initialPageSize = 6; // Load 6 cards initially
  static const int _pageSize = 2; // Load 2 cards for subsequent loads
  Adventure? _lastDocument;
  bool _isInitialLoad = true;

  PaginatedAdventuresNotifier(this._adventureCrudService)
      : super(const PaginatedAdventuresState());

  Future<void> loadInitial() async {
    if (state.isLoading) return;

    print('📥 Loading initial adventures...');
    state = state.copyWith(isLoading: true, error: null);
    _isInitialLoad = true;

    try {
      final adventures = await _adventureCrudService.readPaginated(
        limit: _initialPageSize,
        startAfter: null,
      );

      print('📦 Received ${adventures?.length ?? 0} adventures from Firestore');

      if (adventures == null || adventures.isEmpty) {
        print('⚠️ No adventures found');
        state = state.copyWith(
          adventures: [],
          isLoading: false,
          hasMore: false,
        );
        _isInitialLoad = false;
        return;
      }

      _lastDocument = adventures.last;

      // If odd count > 6, load one more to make it even
      List<Adventure> finalAdventures = adventures;
      if (adventures.length > _initialPageSize && adventures.length % 2 == 1) {
        print('⚠️ Odd number (${adventures.length}), loading 1 more...');

        final oneMore = await _adventureCrudService.readPaginated(
          limit: 1,
          startAfter: _lastDocument,
        );

        if (oneMore != null && oneMore.isNotEmpty) {
          _lastDocument = oneMore.last;
          finalAdventures = [...adventures, ...oneMore];
          print('✅ Added 1 more, total: ${finalAdventures.length}');
        }
      }

      final hasMore = adventures.length >= _initialPageSize;

      print('✅ Initial load complete: ${finalAdventures.length} adventures');
      print('🔄 Has more: $hasMore');

      state = state.copyWith(
        adventures: finalAdventures,
        isLoading: false,
        hasMore: hasMore,
      );

      _isInitialLoad = false;
    } catch (e) {
      print('❌ Error loading adventures: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      _isInitialLoad = false;
    }
  }

  Future<void> loadMore() async {
    print('🔄 loadMore called - isLoading: ${state.isLoading}, hasMore: ${state.hasMore}');

    if (state.isLoading || !state.hasMore) {
      print('⏸️ Skipping loadMore');
      return;
    }

    print('📥 Loading more adventures...');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final adventures = await _adventureCrudService.readPaginated(
        limit: _pageSize,
        startAfter: _lastDocument,
      );

      print('📦 Received ${adventures?.length ?? 0} more adventures');

      if (adventures == null || adventures.isEmpty) {
        print('⚠️ No more adventures');
        state = state.copyWith(
          isLoading: false,
          hasMore: false,
        );
        return;
      }

      _lastDocument = adventures.last;

      final hasMore = adventures.length >= _pageSize;

      print('✅ Added ${adventures.length} adventures');
      print('📊 Total: ${state.adventures.length + adventures.length}');
      print('🔄 Has more: $hasMore');

      state = state.copyWith(
        adventures: [...state.adventures, ...adventures],
        isLoading: false,
        hasMore: hasMore,
      );
    } catch (e) {
      print('❌ Error loading more: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void reset() {
    _lastDocument = null;
    _isInitialLoad = true;
    state = const PaginatedAdventuresState();
  }
}
