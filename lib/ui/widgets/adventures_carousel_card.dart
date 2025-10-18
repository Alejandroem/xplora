import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../domain/models/adventure.dart';
import '../../theme.dart';
import '../../utils/shimmer_widgets.dart';
import '../pages/adventure_detail.dart';

/// Bouncing Card wrapper that listens to scroll events
///
/// This card bounces when the parent carousel scrolls
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

    // Create bounce animation controller with slower duration
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // Slower bounce
    );

    // Vertical bounce animation: move up and back down
    // Uses Offset where dy is the vertical displacement (negative = up)
    _bounceAnimation = TweenSequence<Offset>([
      // Move up
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0, -0.04), // Move up 4% of height (negative = upward)
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      // Move back down
      TweenSequenceItem(
        tween: Tween<Offset>(
          begin: const Offset(0, -0.04),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_bounceController);

    // Listen to scroll trigger
    widget.scrollTrigger.addListener(_onScrollTrigger);
  }

  @override
  void dispose() {
    widget.scrollTrigger.removeListener(_onScrollTrigger);
    _bounceController.dispose();
    super.dispose();
  }

  void _onScrollTrigger() {
    // Trigger bounce when scroll event is detected
    if (mounted && !_bounceController.isAnimating) {
      _bounceController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // SlideTransition moves the widget vertically without affecting layout or other cards
    return SlideTransition(
      position: _bounceAnimation,
      child: widget.child,
    );
  }
}

class AdventuresCarouselCard extends ConsumerStatefulWidget {
  final Adventure adventure;
  const AdventuresCarouselCard(this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdventuresCarouselCardState();
}

class _AdventuresCarouselCardState extends ConsumerState<AdventuresCarouselCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize fade-in animation controller
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Create fade animation (0.0 to 1.0)
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Create scale animation for initial bounce (0.8 to 1.0)
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutBack, // Bounce effect
    ));

    // Start the fade-in animation after a brief delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _fadeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String _getDistance() {
    final location = ref.watch(locationProvider);
    if (location.position != null) {
      final distance = Geolocator.distanceBetween(
        location.position!.latitude,
        location.position!.longitude,
        widget.adventure.latitude,
        widget.adventure.longitude,
      );
      if (distance < 1000) {
        return '${distance.toStringAsFixed(0)}m';
      } else {
        return '${(distance / 1000).toStringAsFixed(0)}km';
      }
    }
    return '--';
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire card with fade and scale animations
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AdventureDetail('carousel', widget.adventure),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: 160,
              child: GlassContainer(
            borderRadius: 12,
            padding: const EdgeInsets.all(0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: 'adventure-image-${widget.adventure.id}-carousel',
                    child: CachedNetworkImage(
                      imageUrl: widget.adventure.imageUrl,
                      height: 200,
                      width: 160,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => ShimmerWidgets.adventureCardShimmer(
                        width: 160,
                        height: 200
                      ),
                      errorWidget: (context, url, error) {
                        return Container(
                          height: 200,
                          color: const Color(0xff121212),
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Hero(
                            tag: 'adventure-title-${widget.adventure.id}-carousel',
                            child: Text(
                              widget.adventure.title,
                              style: subHeadingLabelStyle.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: textPrimary,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 2),
                                    Flexible(
                                      child: Text(
                                        '${widget.adventure.experience.toInt()} XP',
                                        style: bodyTextStyle.copyWith(
                                          fontSize: 11,
                                          color: textPrimary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: textPrimary,
                                      size: 12,
                                    ),
                                    Flexible(
                                      child: Text(
                                        _getDistance(),
                                        style: bodyTextStyle.copyWith(
                                          fontSize: 11,
                                          color: textPrimary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 6),
                          // PrimaryButton(
                          //   text: 'Start Quest',
                          //   onPressed: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (context) => AdventureDetail('carousel', widget.adventure),
                          //       ),
                          //     );
                          //   },
                          //   fontSize: 11,
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: 8,
                          //     vertical: 4,
                          //   ),
                          // ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        ),
      ),
    );
  }

  String formatSeconds(int timeInSeconds) {
    //return min, sec, h, min, d, h, w, d
    if (timeInSeconds < 60) {
      return '${timeInSeconds}s';
    } else if (timeInSeconds < 3600) {
      return '${(timeInSeconds / 60).floor()}m';
    } else if (timeInSeconds < 86400) {
      return '${(timeInSeconds / 3600).floor()}h';
    } else if (timeInSeconds < 604800) {
      return '${(timeInSeconds / 86400).floor()}d';
    } else if (timeInSeconds < 2419200) {
      return '${(timeInSeconds / 604800).floor()}w';
    } else {
      return '${(timeInSeconds / 2419200).floor()}mon';
    }
  }
}
