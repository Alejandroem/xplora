import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../components/feed_components.dart';
import 'adventures_carousel_card.dart';

class NearestAdventures extends ConsumerWidget {
  const NearestAdventures({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedActivityTypes = ref.watch(selectedActivityTypesProvider);

    // Check if location tracking is enabled (user granted permission through custom dialog)
    final locationTrackingEnabled = ref.watch(locationTrackingEnabledProvider);

    if (!locationTrackingEnabled) {
      return const SizedBox
          .shrink(); // Don't show carousel if location tracking not enabled
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Row(
              children: [
                Text(
                  'Places',
                  style: h2Style.copyWith(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(nearbyAdventuresProvider).when(
                      data: (adventures) {
                        // Filter adventures based on selected activity types
                        List<Adventure> filteredAdventures = adventures;

                        if (selectedActivityTypes.isNotEmpty) {
                          filteredAdventures = adventures
                              .where((adventure) =>
                                  selectedActivityTypes.contains(adventure.category))
                              .toList();
                        }

                        // TODO: Implement 'For You' and 'Following' filter logic
                        // For now, all filters use nearby adventures
                        // selectedFilter can be used here to implement different logic

                        if (filteredAdventures.isNotEmpty) {
                          const maxCards = 20;
                          final displayedAdventures =
                              filteredAdventures.take(maxCards).toList();
                          final hasMore = filteredAdventures.length > maxCards;
                          final itemCount = displayedAdventures.length + (hasMore ? 1 : 0);

                          // Use custom carousel with scroll notification
                          return BouncingCarousel(
                            displayedAdventures: displayedAdventures,
                            hasMore: hasMore,
                            onSeeMoreTap: () {
                              ref
                                  .read(bottomNavigationBarProvider.notifier)
                                  .state = NavigationItem.search;
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              selectedActivityTypes.isNotEmpty
                                  ? 'No adventures found for selected activity types'
                                  : 'No adventures found nearby',
                              style:
                                  bodyTextStyle.copyWith(color: textSecondary),
                            ),
                          );
                        }
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                      error: (error, stack) => Center(
                        child: Text(
                          'Error: $error',
                          style: bodyTextStyle.copyWith(color: feedbackAlert),
                        ),
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// A smooth-scrolling filter row with snap-to-edge behavior and easing animations
///
/// Features:
/// - Smooth easing using Curves.easeInOut for all scroll animations
/// - Snap-to-nearest-item when user stops scrolling
/// - Tap-to-center animation when a filter is selected
class SmoothFilterScrollRow extends StatefulWidget {
  final List<String> filters;
  final String selectedFilter;
  final List<String> selectedActivityTypes;
  final Function(String) onFilterTap;
  final Future<void> Function() onActivityTypesTap;

  const SmoothFilterScrollRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.selectedActivityTypes,
    required this.onFilterTap,
    required this.onActivityTypesTap,
  });

  @override
  State<SmoothFilterScrollRow> createState() => _SmoothFilterScrollRowState();
}

class _SmoothFilterScrollRowState extends State<SmoothFilterScrollRow>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  // Keys to track each filter bubble's position
  final List<GlobalKey> _filterKeys = [];

  // Track if user is currently scrolling
  bool _isUserScrolling = false;

  // Track if we're performing an animation (to prevent conflicts)
  bool _isAnimating = false;

  // Track if activity types modal was recently opened
  bool _activityTypesModalOpened = false;

  @override
  void initState() {
    super.initState();

    // Initialize ScrollController with custom physics for smooth scrolling
    _scrollController = ScrollController();

    // Create GlobalKeys for each filter bubble (including activity types)
    _filterKeys.clear();
    for (int i = 0; i < widget.filters.length + 1; i++) {
      _filterKeys.add(GlobalKey());
    }

    // Listen for scroll events to detect when user stops scrolling
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(SmoothFilterScrollRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if activity types changed (items added or removed)
    final activityTypesChanged =
        oldWidget.selectedActivityTypes.length != widget.selectedActivityTypes.length;

    if (activityTypesChanged) {
      // Center the appropriate bubble after a brief delay to allow rebuild
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // If activity types were just cleared, center the active filter
          if (widget.selectedActivityTypes.isEmpty && oldWidget.selectedActivityTypes.isNotEmpty) {
            _activityTypesModalOpened = false;
            _centerActiveFilter();
          } else {
            // Otherwise, center the activity types bubble to show the count
            _activityTypesModalOpened = false;
            _centerActivityTypesBubble();
          }
        }
      });
    } else if (_activityTypesModalOpened && widget.selectedActivityTypes.isEmpty) {
      // Modal was opened but no activity types are selected
      // This handles the case where user opened modal but didn't select anything
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _activityTypesModalOpened = false;
          _centerActiveFilter();
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Centers the currently active filter (Nearby, For You, or Following)
  void _centerActiveFilter() {
    // Find the index of the currently selected filter
    final activeFilterIndex = widget.filters.indexOf(widget.selectedFilter);
    if (activeFilterIndex != -1) {
      _centerItem(activeFilterIndex);
    }
  }

  /// Centers the activity types bubble (last item in the list)
  void _centerActivityTypesBubble() {
    // The activity types bubble is always the last item
    final activityTypesIndex = widget.filters.length;
    _centerItem(activityTypesIndex);
  }

  /// Handles scroll events and triggers snap behavior when scrolling stops
  void _onScroll() {
    // Detect when user starts scrolling
    if (_scrollController.position.isScrollingNotifier.value) {
      if (!_isUserScrolling && !_isAnimating) {
        setState(() {
          _isUserScrolling = true;
        });
      }
    } else {
      // User stopped scrolling - trigger snap behavior
      if (_isUserScrolling && !_isAnimating) {
        setState(() {
          _isUserScrolling = false;
        });
        _snapToNearestItem();
      }
    }
  }

  /// Snaps to the nearest filter bubble using smooth easing animation
  ///
  /// This calculates which bubble is closest to the viewport center
  /// and animates the scroll position to center that bubble
  void _snapToNearestItem() {
    if (_isAnimating) return;

    // Get the current scroll position
    final scrollOffset = _scrollController.offset;
    final viewportWidth = _scrollController.position.viewportDimension;
    final viewportCenter = scrollOffset + (viewportWidth / 2);

    // Find the nearest item to the viewport center
    double? nearestItemCenter;
    double minDistance = double.infinity;

    for (final key in _filterKeys) {
      final RenderBox? renderBox =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        // Get item's position relative to the scroll view
        final itemPosition = renderBox.localToGlobal(Offset.zero);
        final scrollViewPosition =
            _scrollController.position.context.notificationContext!
                .findRenderObject() as RenderBox;
        final itemRelativePosition =
            scrollViewPosition.globalToLocal(itemPosition);

        // Calculate item's center position in scroll coordinates
        final itemCenter =
            scrollOffset + itemRelativePosition.dx + (renderBox.size.width / 2);

        // Check if this is the nearest item
        final distance = (itemCenter - viewportCenter).abs();
        if (distance < minDistance) {
          minDistance = distance;
          nearestItemCenter = itemCenter;
        }
      }
    }

    // Animate to center the nearest item with smooth easing
    if (nearestItemCenter != null) {
      final targetOffset =
          nearestItemCenter - (viewportWidth / 2);

      // Clamp to valid scroll range
      final clampedOffset = targetOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      _animateToOffset(clampedOffset);
    }
  }

  /// Animates to a specific scroll offset using Curves.easeInOut
  Future<void> _animateToOffset(double offset) async {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    // Use easeInOut curve for smooth, natural-feeling animation
    await _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut, // Smooth easing as requested
    );

    setState(() {
      _isAnimating = false;
    });
  }

  /// Centers a specific filter bubble when tapped
  ///
  /// This provides smooth tap-to-center animation using easeInOut
  void _centerItem(int index) {
    if (_isAnimating) return;

    final key = _filterKeys[index];
    final RenderBox? renderBox =
        key.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null) {
      // Calculate the item's position
      final itemPosition = renderBox.localToGlobal(Offset.zero);
      final scrollViewPosition =
          _scrollController.position.context.notificationContext!
              .findRenderObject() as RenderBox;
      final itemRelativePosition =
          scrollViewPosition.globalToLocal(itemPosition);

      // Calculate scroll offset needed to center this item
      final scrollOffset = _scrollController.offset;
      final viewportWidth = _scrollController.position.viewportDimension;
      final itemCenter = scrollOffset + itemRelativePosition.dx +
          (renderBox.size.width / 2);
      final targetOffset = itemCenter - (viewportWidth / 2);

      // Clamp and animate
      final clampedOffset = targetOffset.clamp(
        _scrollController.position.minScrollExtent,
        _scrollController.position.maxScrollExtent,
      );

      _animateToOffset(clampedOffset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 2, 8.0, 12.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // Use BouncingScrollPhysics for natural, smooth scrolling behavior
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // Build filter bubbles
            ...widget.filters.asMap().entries.map((entry) {
              final index = entry.key;
              final filter = entry.value;
              final isSelected = widget.selectedFilter == filter;

              return Padding(
                key: _filterKeys[index],
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterBubble(
                  text: filter,
                  isSelected: isSelected,
                  onTap: () {
                    // Animate to center this filter when tapped
                    _centerItem(index);
                    widget.onFilterTap(filter);
                  },
                ),
              );
            }),

            // Activity Types dropdown bubble
            Padding(
              key: _filterKeys[widget.filters.length],
              padding: const EdgeInsets.only(right: 8.0),
              child: FilterBubble(
                text: widget.selectedActivityTypes.isEmpty
                    ? 'Specific'
                    : 'Specific (${widget.selectedActivityTypes.length})',
                isSelected: widget.selectedActivityTypes.isNotEmpty,
                onTap: () async {
                  // Mark that modal is being opened
                  _activityTypesModalOpened = true;

                  // Animate to center before showing modal
                  _centerItem(widget.filters.length);

                  // Show modal and wait for it to close
                  await widget.onActivityTypesTap();

                  // Wait a brief moment for any state updates to propagate
                  await Future.delayed(const Duration(milliseconds: 50));

                  // If modal was closed and no activity types are selected, center active filter
                  if (mounted && _activityTypesModalOpened && widget.selectedActivityTypes.isEmpty) {
                    _activityTypesModalOpened = false;
                    _centerActiveFilter();
                  }
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 18,
                  color: textPrimary,
                ),
                iconAtEnd: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bouncing Carousel with scroll-triggered bounce animations
///
/// This widget manages scroll state and notifies cards when to bounce
class BouncingCarousel extends StatefulWidget {
  final List<Adventure> displayedAdventures;
  final bool hasMore;
  final VoidCallback onSeeMoreTap;

  const BouncingCarousel({
    super.key,
    required this.displayedAdventures,
    required this.hasMore,
    required this.onSeeMoreTap,
  });

  @override
  State<BouncingCarousel> createState() => _BouncingCarouselState();
}

class _BouncingCarouselState extends State<BouncingCarousel> {
  late ScrollController _scrollController;

  // ValueNotifier to broadcast scroll events to all cards
  final ValueNotifier<int> _scrollTrigger = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTrigger.dispose();
    super.dispose();
  }

  // Listen to scroll and trigger bounce on cards
  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
      // Increment trigger to notify all listening cards
      print('📜 Scroll detected - triggering bounce');
      _scrollTrigger.value++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.displayedAdventures.length + (widget.hasMore ? 1 : 0);

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Show "See more" card at the end if hasMore
        if (index == widget.displayedAdventures.length && widget.hasMore) {
          return InkWell(
            onTap: widget.onSeeMoreTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: GlassContainer(
                borderRadius: 12,
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        color: accentSecondary,
                        size: 40,
                      ),
                      Text(
                        'See more',
                        style: subHeadingLabelStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Return adventure card with bounce capability
        return BouncingCard(
          scrollTrigger: _scrollTrigger,
          index: index,
          child: AdventuresCarouselCard(
            widget.displayedAdventures[index],
          ),
        );
      },
    );
  }
}
