import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../domain/models/adventure.dart';

class FeaturedAdventure extends ConsumerStatefulWidget {
  final Adventure adventure;
  const FeaturedAdventure(this.adventure, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeaturedAdventureState();
}

class _FeaturedAdventureState extends ConsumerState<FeaturedAdventure> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Image.network(
              widget.adventure.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 160,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                'Exp. ${widget.adventure.experience.toStringAsFixed(2)}',
                style: TextStyle(
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
                      widget.adventure.title,
                      style: TextStyle(
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
                            '${widget.adventure.latitude}, ${widget.adventure.longitude}'
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
      ),
    );
  }
}
