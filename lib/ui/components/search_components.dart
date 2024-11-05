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
    final nearbyAdventures = ref.watch(searchItemsProvider);

    return Container(
      height: MediaQuery.of(context).size.height,
      color: raisingBlack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 48, 18, 18),
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
          Expanded(
            child: nearbyAdventures.when(
              data: (data) {
                final filteredData = data.where((element) {
                  final query = _searchQuery.toLowerCase();
                  if (element is Adventure) {
                    return element.title.toLowerCase().contains(query) ||
                        element.shortDescription
                            .toLowerCase()
                            .contains(query) ||
                        element.longDescription.toLowerCase().contains(query);
                  } else if (element is Quest) {
                    return element.title.toLowerCase().contains(query) ||
                        element.shortDescription
                            .toLowerCase()
                            .contains(query) ||
                        element.longDescription.toLowerCase().contains(query);
                  }
                  return false;
                }).toList();

                return ListView.builder(
                  itemCount: (filteredData.length / 5).ceil(),
                  itemBuilder: (context, rowIndex) {
                    final startIndex = rowIndex * 5;
                    final endIndex =
                        (startIndex + 5).clamp(0, filteredData.length);
                    final chunk = filteredData.sublist(startIndex, endIndex);

                    final items = List.generate(
                      5,
                      (i) => i < chunk.length ? chunk[i] : null,
                    );

                    return SearchRow(
                      leadingFrist: rowIndex % 2 == 0,
                      itemOne: items[0],
                      itemTwo: items[1],
                      itemThree: items[2],
                      itemFour: items[3],
                      itemFive: items[4],
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
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
