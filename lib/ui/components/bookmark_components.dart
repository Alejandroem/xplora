import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/boomark_providers.dart';
import '../../application/providers/place_providers.dart';
import '../../domain/models/bookmark.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../pages/place_detail.dart';

class BoomarkComponents extends ConsumerStatefulWidget {
  const BoomarkComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BoomarkComponentsState();
}

class _BoomarkComponentsState extends ConsumerState<BoomarkComponents> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: ref.watch(currentUserBookmarksStreamProvider).when(
            data: (bookmarks) {
              if (bookmarks == null || bookmarks.isEmpty) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'You have no bookmarks yet.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Go to the search page to bookmark places.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Icon(
                      Icons.bookmark,
                      size: 50,
                    ),
                  ],
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    final placeCrudService = ref.read(placeCrudServiceProvider);

                    if (bookmark.type == BookmarkType.place) {
                      return FutureBuilder(
                        future: placeCrudService.read(bookmark.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            final place = snapshot.data as Place;
                            final imageUrl = place.imageUrls.isNotEmpty
                                ? place.imageUrls.first
                                : null;
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PlaceDetail(
                                        'bookmarks',
                                        place,
                                      );
                                    },
                                  ),
                                );
                              },
                              contentPadding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              tileColor: context.colors.bgSecondary,
                              leading: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.place, size: 50),
                              title: Text(place.name),
                              subtitle: Text(place.description ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await ref
                                      .read(bookmarkToggleProvider(bookmark.id)
                                          .notifier)
                                      .toggle(bookmark);
                                },
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      );
                    }
                    return const SizedBox();
                  },
                );
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          ),
    );
  }
}
