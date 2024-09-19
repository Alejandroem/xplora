import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/adventure.dart';

class AdventureDetail extends ConsumerStatefulWidget {
  final String source;
  final Adventure adventure;
  const AdventureDetail(this.source, this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdventureDetailState();
}

class _AdventureDetailState extends ConsumerState<AdventureDetail>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _firstSlideAnimation;
  late Animation<Offset> _secondSlideAnimation;
  late Animation<Offset> _thirdSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _firstFadeAnimation;
  late Animation<double> _secondFadeAnimation;
  late Animation<double> _thirdFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Slide animation for title
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Starting from below
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );

    // Slide animations with increased offset
    _firstSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 3.0), // Starting further down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _secondSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 3.0), // Starting further down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _thirdSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 3.0), // Starting further down
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // Fade animations
    _titleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _firstFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _secondFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
      ),
    );

    _thirdFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start the animation after the hero transition completes
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'adventure-image-${widget.adventure.id}-${widget.source}',
            child: Image.network(
              widget.adventure.imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          // Slide and Fade for title
          SlideTransition(
            position: _titleSlideAnimation,
            child: FadeTransition(
              opacity: _titleFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.adventure.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          // First padding widget (shortDescription)
          SlideTransition(
            position: _firstSlideAnimation,
            child: FadeTransition(
              opacity: _firstFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.adventure.shortDescription),
              ),
            ),
          ),
          // Second padding widget (longDescription)
          SlideTransition(
            position: _secondSlideAnimation,
            child: FadeTransition(
              opacity: _secondFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.adventure.longDescription),
              ),
            ),
          ),
          // Third padding widget (experience)
          SlideTransition(
            position: _thirdSlideAnimation,
            child: FadeTransition(
              opacity: _thirdFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Exp. ${widget.adventure.experience.toStringAsFixed(2)}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
