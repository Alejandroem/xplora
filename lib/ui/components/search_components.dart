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

class SearchComponents extends ConsumerStatefulWidget {
  const SearchComponents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchComponentsState();
}

class _SearchComponentsState extends ConsumerState<SearchComponents> {
  String _searchQuery = '';
  late ScrollController _scrollController;
  late ScrollController _categoryScrollController;
  bool _showSearchBar = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _categoryScrollController = ScrollController();
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
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void scrollToCategory(String categoryId) {
    if (categoryId.isEmpty) return;

    ref.watch(allCategories).whenData(
      (categories) {
        final index =
            categories.indexWhere((element) => element.id == categoryId);
        if (index == -1) return;

        const itemWidth = 88.0; // width (80) + margin (8)

        if(_categoryScrollController.hasClients) {
          final viewportWidth = _categoryScrollController.position.viewportDimension;

          // Center the category in the viewport
          final scrollPosition = (index * itemWidth) - (viewportWidth / 2) + (itemWidth / 2);

          // Clamp to valid scroll range
          final clampedPosition = scrollPosition.clamp(
            _categoryScrollController.position.minScrollExtent,
            _categoryScrollController.position.maxScrollExtent,
          );

          _categoryScrollController.animateTo(
            clampedPosition,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nearbyItems = ref.watch(searchItemsProvider);

    return GradientBackground(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - kBottomNavigationBarHeight,
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
                          child: XploraTextField(
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            style: bodyTextStyle.copyWith(
                              color: textPrimary,
                            ),
                              hintText: 'Find your next adventure',
                              prefixIcon: Icon(
                                Icons.search, 
                                color: textSecondary,
                                size: 20,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                          ),
                        ),
                        //icon to toggle filters
                        Stack(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.filter_list,
                                color: textPrimary,
                                size: 24,
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
                    SingleChildScrollView(
                      controller: _categoryScrollController,
                      scrollDirection: Axis.horizontal,
                      child: IntrinsicHeight(
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
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8),
                                          child: InkWell(
                                            onTap: () {
                                              if (ref.read(selectedCategoriesProvider) == category.id) {
                                                ref.read(selectedCategoriesProvider.notifier).state = '';
                                              } else {
                                                ref.read(selectedCategoriesProvider.notifier).state = category.id;
                                              }
                                            },
                                            child: Container(
                                              width: 80,
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 8,
                                              ),
                                              decoration: BoxDecoration(
                                                color: ref.watch(selectedCategoriesProvider) == category.id
                                                    ? brandPrimary
                                                    : Colors.transparent,
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: ref.watch(selectedCategoriesProvider) == category.id
                                                      ? brandPrimary
                                                      : brandPrimary.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                                boxShadow: ref.watch(selectedCategoriesProvider) == category.id
                                                    ? [
                                                        BoxShadow(
                                                          color: brandPrimary.withOpacity(0.3),
                                                          blurRadius: 8,
                                                          spreadRadius: 0,
                                                        ),
                                                      ]
                                                    : null,
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.network(
                                                    category.imageUrl,
                                                    height: 24,
                                                    width: 24,
                                                    fit: BoxFit.cover,
                                                    color: ref.watch(selectedCategoriesProvider) == category.id
                                                        ? textPrimary
                                                        : textSecondary,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    category.name,
                                                    style: bodyTextStyle.copyWith(
                                                      color: ref.watch(selectedCategoriesProvider) == category.id
                                                          ? textPrimary
                                                          : textSecondary,
                                                      fontSize: 10,
                                                      fontWeight: ref.watch(selectedCategoriesProvider) == category.id
                                                          ? FontWeight.bold
                                                          : FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    maxLines: null,
                                                  ),
                                                ],
                                              ),
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
                        'No adventures found',
                        style: bodyTextStyle.copyWith(
                          color: textSecondary,
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
                                style: subHeadingLabelStyle.copyWith(
                                  color: textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Quest',
                                style: bodyTextStyle.copyWith(
                                  color: textSecondary,
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
                                    style: subHeadingLabelStyle.copyWith(
                                      color: textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Adventure',
                                    style: bodyTextStyle.copyWith(
                                      color: textSecondary,
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
      ),
    );
  }
}
