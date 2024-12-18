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
  int minimumDistance = 500000;
  bool filtersVisible = false;

  @override
  Widget build(BuildContext context) {
    final nearbyItems = ref.watch(searchItemsProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 56, 0, 60),
      height: MediaQuery.of(context).size.height,
      color: raisingBlack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: Column(
              children: [
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
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
                      //icon to toggle filters
                      IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            filtersVisible = !filtersVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (filtersVisible)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.filter_list,
                              color: Colors.white,
                              size: 20,
                            ),
                            //Quest Adventure of all selector
                            const SizedBox(width: 25),
                            DropdownButton<String>(
                              dropdownColor: Colors.black,
                              style: const TextStyle(
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
                                    style: const TextStyle(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            DropdownButton<int>(
                              dropdownColor: Colors.black,
                              style: const TextStyle(
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
                                DropdownMenuItem(
                                  value: 20000,
                                  child: Text(
                                    '20 km',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 50000,
                                  child: Text(
                                    '50 km',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 100000,
                                  child: Text(
                                    '100 km',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                //500
                                DropdownMenuItem(
                                  value: 500000,
                                  child: Text(
                                    '500 km',
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
                            const Icon(
                              Icons.category_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            DropdownButton<String>(
                              dropdownColor: Colors.black,
                              style: const TextStyle(
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
                                    style: const TextStyle(
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
                          ],
                        ),
                      ],
                    ),
                  )
              ],
            ),
          ),
          Expanded(
            child: nearbyItems.when(
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
                  } else if (element is Quest) {
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

                //sort them by distance
                filteredData.sort((a, b) {
                  if (a is Adventure && b is Adventure) {
                    return Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            a.latitude,
                            a.longitude)
                        .compareTo(Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            b.latitude,
                            b.longitude));
                  } else if (a is Quest &&
                      b is Quest &&
                      (a.stepType == QuestType.location ||
                          a.stepType == QuestType.timeLocation) &&
                      (b.stepType == QuestType.location ||
                          b.stepType == QuestType.timeLocation)) {
                    return Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            a.stepLatitude!,
                            a.stepLongitude!)
                        .compareTo(Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            b.stepLatitude!,
                            b.stepLongitude!));
                  }
                  return 0;
                });

                return ListView.builder(
                  itemCount: (filteredData.length ?? 0),
                  itemBuilder: (context, rowIndex) {
                    final item = filteredData[rowIndex];

                    //if quest
                    if (item is Quest) {
                      return Card(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          trailing: Builder(builder: (builder) {
                            if (item.stepType == QuestType.location) {
                              return const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 40,
                              );
                            }

                            if (item.stepType == QuestType.timeLocation) {
                              return const Icon(
                                Icons.timer,
                                color: Colors.white,
                                size: 40,
                              );
                            }

                            if (item.stepType == QuestType.qr) {
                              return const Icon(
                                Icons.text_fields,
                                color: Colors.white,
                                size: 40,
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          title: Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Quest",
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }

                    if (item is Adventure) {
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              height: 200,
                              width: double.infinity,
                            ),
                            ListTile(
                              title: Text(
                                item.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Adventure",
                                style: const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return const SizedBox.shrink();
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
