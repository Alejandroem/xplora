import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/boomark_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/bookmark.dart';
import '../../theme.dart';
import '../pages/adventure_detail.dart';

class BoomarkComponents extends ConsumerStatefulWidget {
  const BoomarkComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BoomarkComponentsState();
}

class _BoomarkComponentsState extends ConsumerState<BoomarkComponents> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: ref.watch(currentUserBoomarksStreamProvider).when(
                  data: (bookmarks) {
                    if (bookmarks == null || bookmarks.isEmpty) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'You have no bookmarks yet.',
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Go to the search page to bookmark adventures.',
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
                      return Column(
                        children: bookmarks.map(
                          (bookmark) {
                            final adventureCrudService = ref.read(
                              adventuresCrudServiceProvider,
                            );

                            if (bookmark.type == BookmarkType.adventure) {
                              return FutureBuilder(
                                future: adventureCrudService
                                    .read(bookmark.entityId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    final adventure =
                                        snapshot.data as Adventure;
                                    return ListTile(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AdventureDetail(
                                                'bookmarks',
                                                adventure,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      contentPadding: const EdgeInsets.all(8.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      tileColor: whiteSmoke,
                                      leading: Image.network(
                                        adventure.imageUrl,
                                        width: 50,
                                        height: 50,
                                      ),
                                      title: Text(
                                        adventure.title,
                                      ),
                                      subtitle: Text(
                                        adventure.shortDescription,
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await ref
                                              .read(boomarkCrudServiceProvider)
                                              .delete(bookmark.id!);
                                          ref.invalidate(
                                              currentUserBoomarksStreamProvider);
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
                        ).toList(),
                      );
                    }
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text('Error: $error'),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
