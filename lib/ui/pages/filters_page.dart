import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/filters_providers.dart';
import '../../theme.dart';

class FiltersPage extends ConsumerWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtersState = ref.watch(filtersStateProvider);
    return Scaffold(
      backgroundColor: raisingBlack,
      appBar: AppBar(
        backgroundColor: raisingBlack,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // This styles the back arrow
        title: const Text(
          'Filters',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Row(
                  children: [
                    Text(
                      'What do you want to explore?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.all_inclusive,
                            size: 32,
                            color: filtersState.selectedType == 'All'
                                ? Colors.blue
                                : Colors.white,
                          ),
                          Text(
                            'All',
                            style: TextStyle(
                              color: filtersState.selectedType == 'All'
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(
                          selectedType: 'All',
                        );
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.explore,
                            size: 32,
                            color: filtersState.selectedType == 'Adventure'
                                ? Colors.blue
                                : Colors.white,
                          ),
                          Text(
                            'Adventure',
                            style: TextStyle(
                              color: filtersState.selectedType == 'Adventure'
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(selectedType: 'Adventure');
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.flag,
                            size: 32,
                            color: filtersState.selectedType == 'Quest'
                                ? Colors.blue
                                : Colors.white,
                          ),
                          Text(
                            'Quest',
                            style: TextStyle(
                              color: filtersState.selectedType == 'Quest'
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(selectedType: 'Quest');
                      },
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      'How far do you want to travel?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      child: Column(
                        children: [
                          Slider(
                            value: filtersState.minimumDistance.toDouble(),
                            min: 1000,
                            max: 500000,
                            divisions: 100,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                            onChanged: (value) {
                              ref.read(filtersStateProvider.notifier).state =
                                  filtersState.copyWith(
                                      minimumDistance: value.round());
                            },
                          ),
                          Text(
                            '${(filtersState.minimumDistance / 1000).round()} km',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Which category interests you?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ref.watch(allCategories).when(
                          data: (categories) {
                            if (categories.isEmpty) {
                              return const Text(
                                'No categories found',
                                style: TextStyle(color: Colors.white),
                              );
                            }
                            categories.sort((a, b) => a.name.compareTo(b.name));
                            return Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                FilterChip(
                                  selected:
                                      ref.watch(selectedCategoriesProvider) ==
                                          '',
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.category_outlined,
                                        size: 20,
                                        color: ref.watch(
                                                    selectedCategoriesProvider) ==
                                                ''
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('All'),
                                    ],
                                  ),
                                  backgroundColor: raisingBlack,
                                  selectedColor: Colors.blue,
                                  onSelected: (bool selected) {
                                    if (selected) {
                                      ref
                                          .read(selectedCategoriesProvider
                                              .notifier)
                                          .state = '';
                                    }
                                  },
                                ),
                                ...categories
                                    .where((c) => c.id != 'All')
                                    .map((category) {
                                  return FilterChip(
                                    selected:
                                        ref.watch(selectedCategoriesProvider) ==
                                            category.id,
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.network(
                                          category.imageUrl,
                                          height: 20,
                                          width: 20,
                                          color: ref.watch(
                                                      selectedCategoriesProvider) ==
                                                  category.id
                                              ? Colors.white
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(category.name),
                                      ],
                                    ),
                                    backgroundColor: raisingBlack,
                                    selectedColor: Colors.blue,
                                    onSelected: (bool selected) {
                                      if (selected) {
                                        ref
                                            .read(selectedCategoriesProvider
                                                .notifier)
                                            .state = category.id;
                                      }
                                    },
                                  );
                                }),
                              ],
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text(
                            'Error: $error',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                OutlinedButton(
                  onPressed: () {
                    ref.read(selectedCategoriesProvider.notifier).state = '';
                    ref.read(filtersStateProvider.notifier).state =
                        filtersState.copyWith(
                      selectedType: 'All',
                      minimumDistance: 500000,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
