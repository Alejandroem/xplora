import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/search_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../widgets/search_row.dart';

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  String _searchQuery = '';
  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<dynamic>> nearbyAdventures =
        ref.watch(searchItemsProvider);

    return Container(
      height: MediaQuery.of(context).size.height,
      color: raisingBlack,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Find your next adventure',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(5),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    gapPadding: 0,
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            nearbyAdventures.when(
              data: (data) {
                final filteredData = data.where((element) {
                  if (element is Adventure) {
                    return element.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        element.shortDescription
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        element.longDescription
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                  }
                  if (element is Quest) {
                    return element.title
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        element.shortDescription
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        element.longDescription
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                  }
                  return false;
                }).toList(); // Remove null items
                return Expanded(
                  child: ListView.builder(
                    itemCount: (filteredData.length / 5)
                        .ceil(), // Determine number of rows
                    itemBuilder: (context, rowIndex) {
                      // Get the chunk of 5 items for the current row
                      final int startIndex = rowIndex * 5;
                      final int endIndex = startIndex + 5;
                      final List<dynamic> chunk = filteredData.sublist(
                        startIndex,
                        endIndex > filteredData.length
                            ? filteredData.length
                            : endIndex,
                      );

                      // Fill the missing items with null if less than 5
                      final List<dynamic> items = List.generate(
                        5,
                        (i) => i < chunk.length ? chunk[i] : null,
                      );
                      items.addAll([null, null, null, null, null]);

                      return SearchRow(
                        leadingFrist: rowIndex % 2 ==
                            0, // Set leading property based on row index
                        itemOne: items[0],
                        itemTwo: items[1],
                        itemThree: items[2],
                        itemFour: items[3],
                        itemFive: items[4],
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
            ),
          ],
        ),
      ),
    );
  }
}
