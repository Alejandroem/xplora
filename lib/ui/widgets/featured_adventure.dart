import 'dart:async';
import 'dart:developer';
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
          log(e.toString());
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

            /* // Display only the first adventure
            final adventure = data.first; */

            return SizedBox(
              height: 200,
              width: double.infinity,
              child: PageView.builder(
                onPageChanged: (index) => _currentImageIndex = index,
                controller: _pageController,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AdventureDetail('featured', data[index]),
                          ),
                        );
                      },
                      child: data[index].featuredImages == null
                          ? const SizedBox.shrink()
                          : Card(
                              clipBehavior: Clip.hardEdge,
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 160,
                                    child: Image.network(
                                      data[index].featuredImages![0],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) =>
              const Center(child: Text('An error occurred')),
        );
  }
}
