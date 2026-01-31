import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/adventure_providers.dart';
import '../../theme.dart';
import '../pages/place_detail.dart';

// Provider for current featured adventure index
final featuredAdventureIndexProvider = StateProvider<int>((ref) => 0);

class FeaturedAdventure extends ConsumerStatefulWidget {
  const FeaturedAdventure({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeaturedAdventureState();
}

class _FeaturedAdventureState extends ConsumerState<FeaturedAdventure> {
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
      final currentIndex = ref.read(featuredAdventureIndexProvider);
      final adventures = ref.read(featuredAdventuresProvider).value;
      if (adventures != null && adventures.isNotEmpty) {
        final nextIndex = (currentIndex + 1) % adventures.length;
        ref.read(featuredAdventureIndexProvider.notifier).state = nextIndex;
        try {
          _pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          log(e.toString());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentImageIndex = ref.watch(featuredAdventureIndexProvider);

    return ref.watch(featuredAdventuresProvider).when(
          data: (data) {
            if (data == null || data.isEmpty) {
              return const Center(
                  child: Text('No featured adventures available'));
            }

            /* // Display only the first adventure
            final adventure = data.first; */

            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: context.colors.textPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Featured Adventures',
                          style: h3Style.copyWith(
                              color: context.colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  // PageView Section
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        ref
                            .read(featuredAdventureIndexProvider.notifier)
                            .state = index;
                      },
                      controller: _pageController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PlaceDetail('featured', data[index]),
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
                                          height: 186,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                data[index].featuredImages![0],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorWidget:
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
                  ),
                  // Page Indicators
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        data.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          height: 8,
                          width: currentImageIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: currentImageIndex == index
                                ? brandPrimary
                                : context.colors.textSecondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const SizedBox(
              height: 200, child: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) =>
              const Center(child: Text('An error occurred')),
        );
  }
}
