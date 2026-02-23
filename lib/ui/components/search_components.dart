import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../application/providers/place_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/place_card.dart';
import '../widgets/smooth_filter_scroll_row.dart';

// Provider for selected search filter
final selectedSearchFilterProvider = StateProvider<String>((ref) => 'All');

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Load initial data only if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(paginatedPlacesProvider);
      if (state.places.isEmpty && !state.isLoading) {
        ref.read(paginatedPlacesProvider.notifier).loadInitial();
      }
    });
  }

  void _onScroll() {
    if (!mounted) return;

    final state = ref.read(paginatedPlacesProvider);

    // Don't trigger if already loading or no more content
    if (state.isLoading || !state.hasMore) return;

    // Load more when near bottom
    if (_isNearBottom) {
      ref.read(paginatedPlacesProvider.notifier).loadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;

    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent - 380;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(spacing16, spacing16, spacing16, 0),
        child: Column(
          children: [
            // Filter row — only rebuilds when selectedFilter changes
            SizedBox(
              width: double.infinity,
              child: Consumer(
                builder: (context, ref, _) {
                  final selectedFilter =
                      ref.watch(selectedSearchFilterProvider);
                  return SmoothFilterScrollRow(
                    filters: const ['All', 'Nearby', 'Recommended', 'Saved'],
                    selectedFilter: selectedFilter,
                    onFilterTap: (filter) {
                      final userId =
                          ref.read(currentAuthUserIdStreamProvider).value;
                      if (userId == null) {
                        showXploraSnackBar(
                          context,
                          'Please sign in to use filters',
                          isInfo: true,
                          duration: const Duration(seconds: 2),
                        );
                        return;
                      }
                      ref.read(selectedSearchFilterProvider.notifier).state =
                          filter;
                    },
                  );
                },
              ),
            ),
            // Content area — only rebuilds when query or filter changes,
            // and only the active tab's data providers are watched
            Expanded(
              child: Consumer(
                builder: (context, ref, _) {
                  final searchQuery = ref.watch(searchQueryProvider).trim();
                  final selectedFilter =
                      ref.watch(selectedSearchFilterProvider);
                  final isSearching = searchQuery.isNotEmpty;
                  return _buildFilteredContent(
                      ref, selectedFilter, searchQuery, isSearching);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredContent(
    WidgetRef ref,
    String selectedFilter,
    String searchQuery,
    bool isSearching,
  ) {
    switch (selectedFilter) {
      case 'Nearby':
        return _buildComingSoon(icon: Icons.near_me, title: 'Nearby Places');
      case 'Recommended':
        return _buildComingSoon(
            icon: Icons.recommend, title: 'Recommended Places');
      case 'Saved':
        return _buildSavedContent(ref, searchQuery);
      case 'All':
      default:
        return isSearching
            ? _buildSearchResults(ref, searchQuery)
            : _buildPaginatedContent(ref);
    }
  }

  // Paginated content for when there's no search query
  Widget _buildPaginatedContent(WidgetRef ref) {
    final state = ref.watch(paginatedPlacesProvider);

    if (state.error != null && state.places.isEmpty) {
      return _buildError(state.error!);
    }

    if (state.places.isEmpty && (state.isLoading || state.hasMore)) {
      return _buildLoadingGrid();
    }

    if (state.places.isEmpty) {
      return _buildEmpty();
    }

    return _buildPlacesGrid(
      places: state.places,
      controller: _scrollController,
      showLoadingShimmer: state.hasMore,
    );
  }

  // Search results for when user types a search query
  Widget _buildSearchResults(WidgetRef ref, String searchQuery) {
    final allPlaces = ref.watch(allPlacesProvider);

    return allPlaces.when(
      data: (places) {
        final query = searchQuery.toLowerCase();
        final filteredPlaces = places.where((place) {
          return place.name.toLowerCase().contains(query) ||
              (place.address?.toLowerCase().contains(query) ?? false) ||
              (place.location?.toLowerCase().contains(query) ?? false);
        }).toList();

        if (filteredPlaces.isEmpty) {
          return _buildNoSearchResults(searchQuery);
        }

        return _buildPlacesGrid(places: filteredPlaces);
      },
      loading: () => _buildLoadingGrid(),
      error: (error, _) => _buildError(error.toString()),
    );
  }

  // Common grid builder
  Widget _buildPlacesGrid({
    required List<Place> places,
    ScrollController? controller,
    bool showLoadingShimmer = false,
  }) {
    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.symmetric(vertical: spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 173 / 222, // 173px width x 222px height
        crossAxisSpacing: spacing12,
        mainAxisSpacing: spacing12,
      ),
      itemCount: places.length + (showLoadingShimmer ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= places.length) {
          return ShimmerWidgets.adventureCardShimmer(
            context: context,
            isInGrid: true,
          );
        }
        return PlaceCard(places[index], isInGrid: true);
      },
    );
  }

  // Loading state with shimmer grid
  Widget _buildLoadingGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 173 / 222, // 173px width x 222px height
        crossAxisSpacing: spacing12,
        mainAxisSpacing: spacing12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ShimmerWidgets.adventureCardShimmer(
          context: context,
          isInGrid: true,
        );
      },
    );
  }

  // Error state
  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error loading places',
            style: bodyTextStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing8),
          Text(
            error,
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Empty state
  Widget _buildEmpty() {
    return Center(
      child: Text(
        'No places found',
        style: bodyTextStyle.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }

  // No search results state
  Widget _buildNoSearchResults(String query) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: iconSizeLarge * 2,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: spacing16),
          Text(
            'No results for "$query"',
            style: h3Style.copyWith(
              color: context.colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: spacing8),
          Text(
            'Try a different search term',
            style: bodyTextStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedContent(WidgetRef ref, String searchQuery) {
    return ref.watch(savedPlacesProvider).when(
          data: (places) {
            if (places.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: iconSizeLarge * 2,
                      color: context.colors.textSecondary,
                    ),
                    const SizedBox(height: spacing16),
                    Text(
                      'No saved places yet',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: spacing8),
                    Text(
                      'Tap the bookmark icon on any place to save it',
                      style: bodyTextStyle.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final query = searchQuery.toLowerCase();
            final filtered = query.isEmpty
                ? places
                : places.where((p) {
                    return p.name.toLowerCase().contains(query) ||
                        (p.location?.toLowerCase().contains(query) ?? false) ||
                        (p.address?.toLowerCase().contains(query) ?? false);
                  }).toList();

            if (filtered.isEmpty) return _buildNoSearchResults(searchQuery);

            return _buildPlacesGrid(places: filtered);
          },
          loading: () => _buildLoadingGrid(),
          error: (error, _) => _buildError(error.toString()),
        );
  }

  // Common "Coming soon" placeholder
  Widget _buildComingSoon({
    required IconData icon,
    required String title,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSizeLarge * 2,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: spacing16),
          Text(
            title,
            style: h3Style.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing8),
          Text(
            'Coming soon',
            style: bodyTextStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
