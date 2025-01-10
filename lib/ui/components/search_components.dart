import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/filters_providers.dart';
import '../../application/providers/location_providers.dart';
import '../../application/providers/search_providers.dart';
import '../../domain/models/adventure.dart';
import '../../domain/models/quest.dart';
import '../../theme.dart';
import '../pages/adventure_detail.dart';
import '../pages/filters_page.dart';
import '../widgets/quest_list.dart';

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  String _searchQuery = '';
  late ScrollController _scrollController;
  bool _showSearchBar = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollToCategory(ref.watch(selectedCategoriesProvider));
    });
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && _showSearchBar) {
        setState(() => _showSearchBar = false);
      } else if (_scrollController.offset <= 0 && !_showSearchBar) {
        setState(() => _showSearchBar = true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(String categoryId) {
    ref.watch(allCategories).whenData(
      (categories) {
        final index =
            categories.indexWhere((element) => element.id == categoryId);
        const itemWidth = 88.0; // width (80) + margin (8)
        final offset = index * itemWidth;
        _scrollController.animateTo(
          offset,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nearbyItems = ref.watch(searchItemsProvider);

    return Container(
      height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
      color: raisingBlack,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            if (_showSearchBar)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  children: [
                    Row(
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
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const FiltersPage(),
                                  ),
                                );
                              },
                            ),
                            if (ref
                                        .watch(filtersStateProvider.notifier)
                                        .state
                                        .selectedType !=
                                    'All' ||
                                ref
                                        .watch(filtersStateProvider.notifier)
                                        .state
                                        .minimumDistance !=
                                    500000 ||
                                ref.watch(selectedCategoriesProvider) != '')
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 70,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: ref.watch(allCategories).when(
                              data: (categories) {
                                return categories.asMap().entries.map(
                                  (entry) {
                                    final category = entry.value;
                                    if (category.name == 'All') {
                                      return const SizedBox.shrink();
                                    }
                                    return Hero(
                                      tag: category.id,
                                      child: InkWell(
                                        onTap: () {
                                          if (ref.read(
                                                  selectedCategoriesProvider) ==
                                              category.id) {
                                            ref
                                                .read(selectedCategoriesProvider
                                                    .notifier)
                                                .state = '';
                                          } else {
                                            ref
                                                .read(selectedCategoriesProvider
                                                    .notifier)
                                                .state = category.id;
                                          }
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ref.watch(
                                                        selectedCategoriesProvider) ==
                                                    category.id
                                                ? Colors.grey[600]
                                                : Colors.grey[200],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.network(
                                                category.imageUrl,
                                                height: 24,
                                                width: 24,
                                                fit: BoxFit.cover,
                                                color: ref.watch(
                                                            selectedCategoriesProvider) ==
                                                        category.id
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              Text(
                                                category.name,
                                                style: TextStyle(
                                                  color: ref.watch(
                                                              selectedCategoriesProvider) ==
                                                          category.id
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList();
                              },
                              loading: () =>
                                  [const CircularProgressIndicator()],
                              error: (Object error, StackTrace stackTrace) {
                                return [Text('Error: $error')];
                              },
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: nearbyItems.when(
                data: (data) {
                  final filters = ref.watch(filtersStateProvider);
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
                          filters.minimumDistance;
                    } else if (element is Quest) {
                      return Geolocator.distanceBetween(
                            location.position!.latitude,
                            location.position!.longitude,
                            element.stepLatitude!,
                            element.stepLongitude!,
                          ) <=
                          filters.minimumDistance;
                    }
                    return false;
                  }).toList();

                  //filter by category
                  final selectedCategory =
                      ref.watch(selectedCategoriesProvider);
                  if (selectedCategory.isNotEmpty) {
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
                  if (filters.selectedType != 'All') {
                    filteredData = filteredData.where((element) {
                      if (element is Adventure &&
                          filters.selectedType == 'Adventure') {
                        return true;
                      } else if (element is Quest &&
                          filters.selectedType == 'Quest') {
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
                    controller: _scrollController,
                    itemCount: (filteredData.length),
                    itemBuilder: (context, rowIndex) {
                      final item = filteredData[rowIndex];

                      //if quest
                      if (item is Quest) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    title: const Text('Quest List'),
                                  ),
                                  body: const QuestList(
                                    isHero: true,
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Card(
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
                              subtitle: const Text(
                                'Quest',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (item is Adventure) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AdventureDetail(
                                  'other',
                                  item,
                                ),
                              ),
                            );
                          },
                          child: Card(
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
                                  subtitle: const Text(
                                    'Adventure',
                                    style: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
