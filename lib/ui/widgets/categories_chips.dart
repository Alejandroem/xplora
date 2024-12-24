import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';

class CategoriesChips extends ConsumerStatefulWidget {
  const CategoriesChips({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesChipsState();
}

class _CategoriesChipsState extends ConsumerState<CategoriesChips> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoriesProvider);

    return ref.watch(allCategories).when(
          data: (categories) {
            // Split categories into two parts
            final half = (categories.length / 2).ceil();
            final firstHalfCategories = categories.sublist(0, half);
            final secondHalfCategories = categories.sublist(half);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_run,
                          color: raisingBlack,
                        ),
                        Text(
                          'Activities',
                          style: TextStyle(
                            fontSize: 20,
                            color: raisingBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: firstHalfCategories.map((category) {
                        final isSelected = selectedCategory == category.id;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Hero(
                            tag: category.id,
                            child: ChoiceChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64),
                              ),
                              showCheckmark: false,
                              selected: isSelected,
                              onSelected: (bool selected) {
                                // Update the selected categories based on the user's selection
                                ref
                                    .read(selectedCategoriesProvider.notifier)
                                    .state = selected ? category.id : '';

                                //change to search page
                                if (selected) {
                                  //change to search page
                                  ref
                                      .watch(
                                          bottomNavigationBarProvider.notifier)
                                      .state = NavigationItem.search;
                                }
                              },
                              backgroundColor:
                                  isSelected ? raisingBlack : Colors.white,
                              label: Row(
                                children: [
                                  Image.network(
                                    category.imageUrl,
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : raisingBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Space between rows

                  // Second scrollable row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: secondHalfCategories.map((category) {
                        final isSelected = selectedCategory == category.id;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Hero(
                            tag: category.id,
                            child: ChoiceChip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64),
                              ),
                              showCheckmark: false,
                              selected: isSelected,
                              onSelected: (bool selected) {
                                // Update the selected categories based on the user's selection
                                ref
                                    .read(selectedCategoriesProvider.notifier)
                                    .state = selected ? category.id : '';

                                if (selected) {
                                  //change to search page
                                  ref
                                      .watch(
                                          bottomNavigationBarProvider.notifier)
                                      .state = NavigationItem.search;
                                }
                              },
                              backgroundColor:
                                  isSelected ? raisingBlack : Colors.white,
                              label: Row(
                                children: [
                                  Image.network(
                                    category.imageUrl,
                                    height: 20,
                                    width: 20,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : raisingBlack,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Error: $error'),
        );
  }
}
