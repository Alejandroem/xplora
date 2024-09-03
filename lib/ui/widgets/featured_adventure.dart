import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/providers/adventure_providers.dart';
import '../../domain/models/adventure.dart';

class FeaturedAdventure extends ConsumerStatefulWidget {
  const FeaturedAdventure({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeaturedAdventureState();
}

class _FeaturedAdventureState extends ConsumerState<FeaturedAdventure> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return ref.watch(featuredAdventuresProvider).when(
      data: (data) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: 160,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: data!.map((adventure) {
                  return Card(
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        Image.network(
                          adventure.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 160,
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Text(
                            'Exp. ${adventure!.experience.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  adventure.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.map,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              final uri = Uri(
                                  scheme: 'google.navigation',
                                  // host: '"0,0"',  {here we can put host}
                                  queryParameters: {
                                    'q':
                                        '${adventure!.latitude}, ${adventure!.longitude}'
                                  });
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri);
                              } else {
                                debugPrint('An error occurred');
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: data.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('An error occurred'),
        );
      },
    );
  }
}
