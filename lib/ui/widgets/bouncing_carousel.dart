import 'package:flutter/material.dart';
import '../../theme.dart';
import 'glass_container.dart';

/// Generic Bouncing Carousel that can display any type of items
class GenericBouncingCarousel<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final bool hasMore;
  final VoidCallback onSeeMoreTap;
  final int? scrollToIndex;

  const GenericBouncingCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.hasMore,
    required this.onSeeMoreTap,
    this.scrollToIndex,
  });

  @override
  State<GenericBouncingCarousel<T>> createState() =>
      _GenericBouncingCarouselState<T>();
}

class _GenericBouncingCarouselState<T>
    extends State<GenericBouncingCarousel<T>> {
  late ScrollController _scrollController;
  final ValueNotifier<int> _scrollTrigger = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Scroll to the selected index after the widget is built
    if (widget.scrollToIndex != null && widget.scrollToIndex! >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          final index = widget.scrollToIndex!;
          // Each card is 168px wide (160px card + 8px padding)
          const cardWidth = 168.0;
          final viewportWidth = _scrollController.position.viewportDimension;

          // Center the card in the viewport
          final scrollPosition = (index * cardWidth) - (viewportWidth / 2) + (cardWidth / 2);

          // Clamp to valid scroll range
          final clampedPosition = scrollPosition.clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          );

          _scrollController.animateTo(
            clampedPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void didUpdateWidget(GenericBouncingCarousel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If scrollToIndex changed, scroll to the new index
    if (widget.scrollToIndex != oldWidget.scrollToIndex &&
        widget.scrollToIndex != null &&
        widget.scrollToIndex! >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          final index = widget.scrollToIndex!;
          const cardWidth = 168.0;
          final viewportWidth = _scrollController.position.viewportDimension;

          // Center the card in the viewport
          final scrollPosition = (index * cardWidth) - (viewportWidth / 2) + (cardWidth / 2);

          // Clamp to valid scroll range
          final clampedPosition = scrollPosition.clamp(
            _scrollController.position.minScrollExtent,
            _scrollController.position.maxScrollExtent,
          );

          _scrollController.animateTo(
            clampedPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollTrigger.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
      _scrollTrigger.value++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length + (widget.hasMore ? 1 : 0);

    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(width: spacing8),
      controller: _scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == widget.items.length && widget.hasMore) {
          return SeeMoreCard(onTap: widget.onSeeMoreTap);
        }

        return BouncingCard(
          scrollTrigger: _scrollTrigger,
          index: index,
          child: widget.itemBuilder(widget.items[index], index),
        );
      },
    );
  }
}

/// Bouncing Card wrapper that listens to scroll events
class BouncingCard extends StatefulWidget {
  final Widget child;
  final ValueNotifier<int> scrollTrigger;
  final int index;

  const BouncingCard({
    super.key,
    required this.child,
    required this.scrollTrigger,
    required this.index,
  });

  @override
  State<BouncingCard> createState() => _BouncingCardState();
}

class _BouncingCardState extends State<BouncingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<Offset> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _bounceAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -0.04),
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_bounceController);

    widget.scrollTrigger.addListener(_onScrollTrigger);
  }

  @override
  void dispose() {
    widget.scrollTrigger.removeListener(_onScrollTrigger);
    _bounceController.dispose();
    super.dispose();
  }

  void _onScrollTrigger() {
    if (mounted && !_bounceController.isAnimating) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _bounceAnimation,
      child: widget.child,
    );
  }
}

/// See More Card for carousels
class SeeMoreCard extends StatelessWidget {
  final VoidCallback onTap;

  const SeeMoreCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(spacing4),
        child: GlassContainer(
          borderRadius: radiusMedium,
          padding: const EdgeInsets.all(spacing16),
          child: SizedBox(
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: context.colors.textSecondary,
                  size: iconSizeLarge*2,
                ),
                Text(
                  'See more',
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
