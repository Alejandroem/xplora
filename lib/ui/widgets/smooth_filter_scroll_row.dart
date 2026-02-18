import 'package:flutter/cupertino.dart' show StatefulWidget;
import 'package:flutter/material.dart';

import '../../theme.dart';

/// A smooth-scrolling filter row with snap-to-edge behavior and easing animations
///
/// Features:
/// - Smooth easing using Curves.easeInOut for all scroll animations
/// - Snap-to-nearest-item when user stops scrolling
/// - Tap-to-center animation when a filter is selected
class SmoothFilterScrollRow extends StatefulWidget {
  final List<String> filters;
  final String selectedFilter;
  // final List<String> selectedActivityTypes;
  final Function(String) onFilterTap;
  // final Future<void> Function() onActivityTypesTap;
  final bool alignCenter;

  const SmoothFilterScrollRow({
    super.key,
    required this.filters,
    required this.selectedFilter,
    // required this.selectedActivityTypes,
    required this.onFilterTap,
    // required this.onActivityTypesTap,
    this.alignCenter = true
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

    // Create GlobalKeys for each filter bubble // (including activity types)
    _filterKeys.clear();
    // for (int i = 0; i < widget.filters.length + 1; i++) {
    for (int i = 0; i < widget.filters.length; i++) {
      _filterKeys.add(GlobalKey());
    }

    // // Listen for scroll events to detect when user stops scrolling
    // _scrollController.addListener(_onScroll);
  }

  /*
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
  */

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Centers the activity types bubble (last item in the list)
  void _centerActivityTypesBubble() {
    // The activity types bubble is always the last item
    final activityTypesIndex = widget.filters.length;
    _centerItem(activityTypesIndex);
  }

  /// Centers the currently active filter (Nearby, For You, or Following)
  void _centerActiveFilter() {
    // Find the index of the currently selected filter
    final activeFilterIndex = widget.filters.indexOf(widget.selectedFilter);
    if (activeFilterIndex != -1) {
      _centerItem(activeFilterIndex);
    }
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
    return Align(
      alignment: widget.alignCenter ? AlignmentGeometry.center : AlignmentDirectional.topStart,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // Use BouncingScrollPhysics for natural, smooth scrolling behavior
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            // Build filter tabs
            ...widget.filters.asMap().entries.map((entry) {
              final index = entry.key;
              final filter = entry.value;
              final isSelected = widget.selectedFilter == filter;
    
              return Padding(
                key: _filterKeys[index],
                padding: EdgeInsets.only(
                  right: index < widget.filters.length - 1 ? spacing32 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    // Animate to center this filter when tapped
                    // _centerItem(index);
                    widget.onFilterTap(filter);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: spacing8),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            filter,
                            textAlign: TextAlign.center,
                            style: bodyTextStyle.copyWith(
                              fontSize: 14,
                              color: isSelected
                                  ? context.colors.textPrimary
                                  : context.colors.textSecondary.withValues(
                                      alpha: 0.5,
                                    ),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: spacing8),
                          // Indicator under text - matches text width exactly
                          Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? brandPrimary
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}