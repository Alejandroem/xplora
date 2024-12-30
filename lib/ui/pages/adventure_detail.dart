import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/bookmark.dart';
import '../../theme.dart';

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
  bool creatingBookmark = false;

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
          Stack(
            fit: StackFit.passthrough,
            children: [
              Hero(
                tag: 'adventure-image-${widget.adventure.id}-${widget.source}',
                child: Image.network(
                  widget.adventure.imageUrl,
                  height: 200,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                top: 25,
                left: 10,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              //boomark icon
              ref
                  .watch(adventureBookmarkProvider(
                    widget.adventure.id!,
                  ))
                  .when(
                    data: (bookmarks) {
                      final bookmark = bookmarks != null && bookmarks.isNotEmpty
                          ? bookmarks.first
                          : null;
                      return Positioned(
                        top: 25,
                        right: 10,
                        child: IconButton(
                          icon: Icon(
                            bookmark != null
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          onPressed: creatingBookmark
                              ? null
                              : () async {
                                  setState(() {
                                    creatingBookmark = true;
                                  });
                                  final bookmarkCrudService =
                                      ref.read(boomarkCrudServiceProvider);
                                  final authService =
                                      ref.read(authServiceProvider);
                                  final user = await authService.getAuthUser();
                                  if (user == null) {
                                    return;
                                  }
                                  if (bookmark == null) {
                                    await bookmarkCrudService.create(
                                      Bookmark(
                                        id: null,
                                        type: BookmarkType.adventure,
                                        entityId: widget.adventure.id!,
                                        userId: user.id!,
                                      ),
                                    );
                                  } else {
                                    bookmarkCrudService.delete(bookmark.id!);
                                  }
                                  ref.invalidate(adventureBookmarkProvider(
                                    widget.adventure.id!,
                                  ));
                                  setState(() {
                                    creatingBookmark = false;
                                  });
                                },
                        ),
                      );
                    },
                    loading: () => const SizedBox(),
                    error: (error, stack) => const SizedBox(),
                  ),
            ],
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
                    'Xp. ${widget.adventure.experience.toStringAsFixed(2)}'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 32),
            child: OutlinedButton(
              onPressed: () async {
                //url launcher to the location
                final url = Uri.parse(
                    'https://www.google.com/maps/search/?api=1&query=${widget.adventure.latitude},${widget.adventure.longitude}');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map,
                    color: raisingBlack,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Open in Google Maps',
                    style: TextStyle(
                      color: raisingBlack,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
