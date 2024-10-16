import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/notifications_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';

class NotificationComponents extends ConsumerStatefulWidget {
  const NotificationComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationComponentsState();
}

class _NotificationComponentsState
    extends ConsumerState<NotificationComponents> {
  @override
  Widget build(BuildContext context) {
    // Watch the userPreviousAdventuresProvider to get the list of adventures
    final userAwarded = ref.watch(userAwardedProvider);

    return userAwarded.when(
      data: (items) {
        // Check if there are adventures and if the list is not null
        if (items.isEmpty) {
          return const SafeArea(
            child: Column(
              children: [
                SizedBox(height: 48),
                Center(
                  child: Text(
                    'No previous awards.',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Visit new places to get awards.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 100,
                  color: Colors.black26,
                ),
              ],
            ),
          );
        }

        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              if (item is Adventure) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0), // Spacing between cards
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: double.infinity, // Make the card full width
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User awarded',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item.experience} XP', // Display the XP from the adventure
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.shortDescription,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 16), // Spacing between text and image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners for the image
                                child: Image.network(
                                  item.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (item is Quest) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0), // Spacing between cards
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: double.infinity, // Make the card full width
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User awarded',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item.experience} XP', // Display the XP from the adventure
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.shortDescription,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                  width: 16), // Spacing between text and image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    10), // Rounded corners for the image
                                child: Image.network(
                                  item.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        );
      },
      loading: () => const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
