import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../widgets/smooth_filter_scroll_row.dart';

// Provider for selected search filter
final selectedSearchFilterProvider = StateProvider<String>((ref) => 'All');

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(String categoryId) {
    if (categoryId.isEmpty) return;
  }

  @override
  Widget build(BuildContext context) {
    final nearbyItems = ref.watch(searchItemsProvider);

    return GradientBackground(
      height: MediaQuery.of(context).size.height*0.78,
      child: Padding(
        padding: const EdgeInsets.all(spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Bubbles Row
            SmoothFilterScrollRow(
              filters: const ['All', 'Nearby', 'Recommended', 'Saved'],
              selectedFilter: ref.watch(selectedSearchFilterProvider),
              onFilterTap: (filter) {
                ref.read(selectedSearchFilterProvider.notifier).state = filter;
              },
            ),
            const SizedBox(height: spacing12),
            Expanded(
              child: nearbyItems.when(
                data: (data) {
                  final filters = ref.watch(filtersStateProvider);
                  final searchQuery = ref.watch(searchQueryProvider);
                  var filteredData = data.where((element) {
                    var query = searchQuery.toLowerCase();
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
                  if (location.position != null) {
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
                  }
              
                  if (filteredData.isEmpty) {
                    return Center(
                      child: Text(
                        'No places found',
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }
              
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
                                style: bodyTextStyle,
                              ),
                              subtitle: Text(
                                'Quest',
                                style: bodyTextStyle.copyWith(
                                  color: context.colors.textSecondary,
                                  fontSize: 14,
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
                                    style: bodyTextStyle,
                                  ),
                                  subtitle: Text(
                                    'Adventure',
                                    style: bodyTextStyle.copyWith(
                                      color: context.colors.textSecondary,
                                      fontSize: 14,
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
