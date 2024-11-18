import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/location_providers.dart';
import '../../application/providers/search_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../../infrastructure/constants.dart';
import '../../theme.dart';
import '../widgets/search_row.dart';

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  String selectedType = 'All';
  String selectedCategory = 'All';
  String _searchQuery = '';
  int minimumDistance = 1000;

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
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 48, 18, 6),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    DropdownButton<int>(
                      dropdownColor: Colors.black,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      value: minimumDistance,
                      items: const [
                        DropdownMenuItem(
                          value: 1000,
                          child: Text(
                            '1 km',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 5000,
                          child: Text(
                            '5 km',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 10000,
                          child: Text(
                            '10 km',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            minimumDistance = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 5),
                    //categories
                    Icon(
                      Icons.category_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      value: selectedCategory,
                      items: [
                        'All',
                        ...categories,
                      ].map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.filter_list,
                      color: Colors.white,
                      size: 20,
                    ),
                    //Quest Adventure of all selector
                    const SizedBox(width: 5),
                    DropdownButton<String>(
                      dropdownColor: Colors.black,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      value: selectedType,
                      items: [
                        'All',
                        'Adventure',
                        'Quest',
                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: nearbyAdventures.when(
              data: (data) {
                var filteredData = data.where((element) {
                  var query = _searchQuery.toLowerCase();
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

                //filter by location
                final location = ref.watch(locationProvider);
                filteredData = filteredData.where((element) {
                  if (location.isLoading || location.position == null) {
                    return true;
                  }
                  if (element is Adventure) {
                    return Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            element.latitude,
                            element.longitude) <=
                        minimumDistance;
                  } else if (element is Quest &&
                      (element.stepType == QuestType.location ||
                          element.stepType == QuestType.timeLocation)) {
                    return Geolocator.distanceBetween(
                          location.position!.latitude,
                          location.position!.longitude,
                          element.stepLatitude!,
                          element.stepLongitude!,
                        ) <=
                        minimumDistance;
                  }
                  return false;
                }).toList();

                //filter by category
                if (selectedCategory != 'All') {
                  filteredData = filteredData.where((element) {
                    if (element is Adventure && element.category != null) {
                      return element.category == selectedCategory;
                    } else if (element is Quest && element.category != null) {
                      return element.category == selectedCategory;
                    }
                    return false;
                  }).toList();
                }

                //filter by type
                if (selectedType != 'All') {
                  filteredData = filteredData.where((element) {
                    if (element is Adventure && selectedType == 'Adventure') {
                      return true;
                    } else if (element is Quest && selectedType == 'Quest') {
                      return true;
                    }
                    return false;
                  }).toList();
                }

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
