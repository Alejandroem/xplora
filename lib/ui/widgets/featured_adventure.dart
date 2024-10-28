import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../pages/adventure_detail.dart';

class FeaturedAdventure extends ConsumerStatefulWidget {
  const FeaturedAdventure({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeaturedAdventureState();
}

class _FeaturedAdventureState extends ConsumerState<FeaturedAdventure> {
  int _currentImageIndex = 0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startSlideshow();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % 3; // Update image index
        try {
          _pageController.animateToPage(
            _currentImageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(featuredAdventuresProvider).when(
          data: (data) {
            if (data == null || data.isEmpty) {
              return const Center(
                  child: Text('No featured adventures available'));
            }

            // Display only the first adventure
            final adventure = data.first;
            final images = [
              'https://picsum.photos/400/300?random=3',
              'https://picsum.photos/400/300?random=4',
              'https://picsum.photos/400/300?random=5'
            ];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AdventureDetail('featured', adventure),
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    children: [
                      // Slideshow using PageView
                      SizedBox(
                        height: 160,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      //centered text with background saying promote your event here
                      Positioned(
                        top: 60,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          padding: const EdgeInsets.all(10),
                          child: const Text(
                            'Promote your event here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('An error occurred')),
        );
  }
}
