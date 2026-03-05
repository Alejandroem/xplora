import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../application/providers/place_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../../utils/snackbar_utils.dart';
import 'carousel_widget.dart';
import 'nearby_places_states.dart';
import 'place_card.dart';
import 'smooth_filter_scroll_row.dart';

// Height of the carousel section — matches the place card height so
// loading/empty/disabled states occupy the same space as real cards.
const double _kCarouselSectionHeight = 220.0;

/*
// Provider for selected activity types (multiple)
final selectedActivityTypesProvider = StateProvider<List<String>>((ref) => []);
 */

// Provider for selected filter
final selectedCarouselFilterProvider = StateProvider<String>((ref) => 'Nearby');

class PlacesSection extends ConsumerStatefulWidget {
  const PlacesSection({super.key});

  @override
  ConsumerState<PlacesSection> createState() => _NearestAdventuresState();
}

class _NearestAdventuresState extends ConsumerState<PlacesSection> {
  static const int _maxCards = 20;
  /*
  Future<void> _showActivityTypesModal(
      BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final selectedTypes = ref.watch(selectedActivityTypesProvider);

          return GlassContainer(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Activity Types',
                        style: h3Style,
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: textPrimary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                ref.watch(allCategories).when(
                      data: (categories) {
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: categories
                              .where((c) => c.name != 'All')
                              .map((category) {
                            final isSelected =
                                selectedTypes.contains(category.id);
                            return FilterBubble(
                              text: category.name,
                              isSelected: isSelected,
                              onTap: () {
                                final currentTypes =
                                    ref.read(selectedActivityTypesProvider);
                                if (isSelected) {
                                  // Remove from selection
                                  ref
                                          .read(selectedActivityTypesProvider
                                              .notifier)
                                          .state =
                                      currentTypes
                                          .where((id) => id != category.id)
                                          .toList();
                                } else {
                                  // Add to selection
                                  ref
                                      .read(selectedActivityTypesProvider
                                          .notifier)
                                      .state = [...currentTypes, category.id];
                                }
                              },
                            );
                          }).toList(),
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => Text('Error: $error',
                          style: TextStyle(color: textPrimary)),
                    ),
                if (selectedTypes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SecondaryButton(
                      text: 'Clear all',
                      onPressed: () {
                        ref.read(selectedActivityTypesProvider.notifier).state =
                            [];
                      },
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
   */
  @override
  Widget build(BuildContext context) {
    // final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

    // Check if location tracking is enabled (user granted permission through custom dialog)
    // final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);
    //
    // if (!locationTrackingEnabled) {
    //   return const SizedBox
    //       .shrink(); // Don't show carousel if location tracking not enabled
    // }

    final selectedFilter = ref.watch(selectedCarouselFilterProvider);
    final filters = ['Nearby', 'For You', 'Following'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: spacing8),
        // Filter Bubble Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: spacing16),
          child: SmoothFilterScrollRow(
            alignCenter: false,
            filters: filters,
            selectedFilter: selectedFilter,
            onFilterTap: (filter) {
              if (filter == selectedFilter) return;

              // Check if user is authenticated
              final userIdAsync = ref.read(currentAuthUserIdStreamProvider);
              final userId = userIdAsync.value;

              if (userId == null) {
                // User not logged in - show message and don't change filter
                showXploraSnackBar(
                  context,
                  'Please sign in to use filters',
                  isInfo: true,
                  duration: const Duration(seconds: 2),
                );
                return;
              }

              // User is authenticated - allow filter change
              ref.read(selectedCarouselFilterProvider.notifier).state = filter;
            },
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.fromLTRB(spacing16, spacing12, spacing16, 0),
          child: Text(
            'Places',
            style: h3Style.copyWith(
              color: context.colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: spacing16),
        Consumer(
          builder: (context, ref, child) {
            // Show "Coming soon" for 'Following' filter
            if (selectedFilter == 'Following') {
              return _buildComingSoon(
                context: context,
                icon: Icons.people_outline,
                title: 'Following',
              );
            }

            // For You — interest-based recommendations
            if (selectedFilter == 'For You') {
              return ref.watch(forYouPlacesProvider).when(
                skipLoadingOnRefresh: false,
                loading: () => _buildLoadingShimmer(context),
                error: (_, __) => _buildError(context, 'Failed to load recommendations. Please try again later.'),
                data: (places) {
                  if (places.isEmpty) {
                    final interests =
                        ref.read(userInterestsProvider).valueOrNull ?? [];
                    return interests.isEmpty
                        ? _buildSetInterests(context)
                        : _buildNoMatches(context);
                  }
                  return _buildPlacesCarousel(places, ref);
                },
              );
            }

            // Resolve all location checks through the centralized provider
            switch (ref.watch(locationReadinessProvider)) {
              case LocationReadiness.loading:
                return _buildLoadingShimmer(context);
              case LocationReadiness.disabled:
                return _buildLocationDisabled();
              case LocationReadiness.ready:
            }

            return ref.watch(nearbyPlacesProvider).when(
              loading: () => _buildLoadingShimmer(context),
              error: (_, __) => _buildError(context, 'Failed to load nearby places. Please try again later.'),
              data: (places) => places.isEmpty
                  ? const SizedBox(
                      height: _kCarouselSectionHeight,
                      child: NearbyEmptyState(),
                    )
                  : _buildPlacesCarousel(places, ref),
            );
          },
        ),
      ],
    );
  }

  /// Common "Coming soon" placeholder (matching search screen pattern)
  Widget _buildComingSoon({
    required BuildContext context,
    required IconData icon,
    required String title,
  }) {
    return SizedBox(
      height: _kCarouselSectionHeight,
      child: Center(
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
      ),
    );
  }

  /// Loading shimmer for place cards
  Widget _buildLoadingShimmer(BuildContext context) {
    return SizedBox(
      height: _kCarouselSectionHeight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: IntrinsicHeight(
          child: Row(
            children: [
              for (int index = 0; index < 3; index++) ...[
                Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? spacing16 : 0,
                    right: index == 2 ? spacing16 : 0,
                  ),
                  child: ShimmerWidgets.adventureCardShimmer(context: context),
                ),
                if (index < 2) const SizedBox(width: spacing8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetInterests(BuildContext context) {
    return SizedBox(
      height: _kCarouselSectionHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.interests_outlined,
              size: iconSizeLarge * 2,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: spacing16),
            Text(
              'No interests selected',
              style: h3Style.copyWith(color: context.colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoMatches(BuildContext context) {
    return SizedBox(
      height: _kCarouselSectionHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: iconSizeLarge * 2,
              color: context.colors.textSecondary,
            ),
            const SizedBox(height: spacing16),
            Text(
              'No matching places yet',
              style: h3Style.copyWith(color: context.colors.textPrimary),
            ),
            const SizedBox(height: spacing8),
            Text(
              "We'll add more places soon",
              style:
                  bodyTextStyle.copyWith(color: context.colors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesCarousel(List<Place> places, WidgetRef ref) {
    final displayedPlaces = places.take(_maxCards).toList();
    final hasMore = places.length > _maxCards;
    return CarouselWidget<Place>(
      items: displayedPlaces,
      itemBuilder: (place, index) => PlaceCard(place),
      hasMore: hasMore,
      onSeeMoreTap: () {
        ref.read(bottomNavigationBarProvider.notifier).state =
            NavigationItem.search;
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return SizedBox(
      height: _kCarouselSectionHeight,
      child: Center(
        child: Text(
          message,
          style: bodyTextStyle.copyWith(color: errorColor),
        ),
      ),
    );
  }

  Widget _buildLocationDisabled() {
    return const SizedBox(
      height: _kCarouselSectionHeight,
      child: LocationRequiredState(),
    );
  }
}
