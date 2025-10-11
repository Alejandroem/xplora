import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
import 'filter_bubble.dart';

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
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 6),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_run,
                          color: iconColor,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'Activities',
                          style: h3Style.copyWith(color: textPrimary),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: firstHalfCategories.map((category) {
                        if (category.name == 'All') {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Hero(
                            tag: category.id,
                            child: FilterBubble(
                              text: category.name,
                              isSelected: false,
                              onTap: () {
                                // Update the selected categories based on the user's selection
                                ref.read(selectedCategoriesProvider.notifier).state = category.id;

                                //change to search page
                                ref.watch(bottomNavigationBarProvider.notifier).state = NavigationItem.search;
                              },
                              icon: CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                height: 20,
                                width: 20,
                                color: textSecondary,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: textSecondary,
                                  size: 20,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              borderRadius: 20,
                              fontSize: 14,
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
                            child: FilterBubble(
                              text: category.name,
                              isSelected: isSelected,
                              onTap: () {
                                // Update the selected categories based on the user's selection
                                ref.read(selectedCategoriesProvider.notifier).state = isSelected ? '' : category.id;

                                if (!isSelected) {
                                  //change to search page
                                  ref.watch(bottomNavigationBarProvider.notifier).state = NavigationItem.search;
                                }
                              },
                              icon: CachedNetworkImage(
                                imageUrl: category.imageUrl,
                                height: 20,
                                width: 20,
                                color: isSelected ? textPrimary : textSecondary,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: isSelected ? textPrimary : textSecondary,
                                  size: 20,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              borderRadius: 20,
                              fontSize: 14,
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
          loading: () => const SizedBox(
            height: 100,
              child: Center(child: CircularProgressIndicator())),
          error: (error, stackTrace) => Text('Error: $error'),
        );
  }
}
