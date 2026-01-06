import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../domain/models/category.dart';
import '../../theme.dart';
import 'bouncing_carousel.dart';
import 'carousel_card.dart';

class CategoriesChips extends ConsumerWidget {
  const CategoriesChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
            child: Row(
              children: [
                Text(
                  'Activities',
                  style: h2Style,
                ),
                const Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: Consumer(
              builder: (context, ref, child) {
                return ref.watch(allCategories).when(
                      data: (categories) {
                        final filteredCategories = categories
                            .where((category) => category.name != 'All')
                            .toList();

                        if (filteredCategories.isNotEmpty) {
                          const maxCards = 20;
                          final displayedCategories =
                              filteredCategories.take(maxCards).toList();
                          final hasMore = filteredCategories.length > maxCards;

                          final selectedCategory =
                              ref.watch(selectedCategoriesProvider);

                          // Find the index of the selected category
                          final selectedIndex = selectedCategory.isNotEmpty
                              ? displayedCategories.indexWhere(
                                  (category) => category.id == selectedCategory)
                              : -1;

                          return GenericBouncingCarousel<Category>(
                            items: displayedCategories,
                            itemBuilder: (category, index) =>
                                CategoryCarouselCard(
                              category,
                              isSelected: selectedCategory == category.id,
                            ),
                            hasMore: hasMore,
                            scrollToIndex: selectedIndex >= 0 ? selectedIndex : null,
                            onSeeMoreTap: () {
                              ref
                                  .read(bottomNavigationBarProvider.notifier)
                                  .state = NavigationItem.search;
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              'No activities found',
                              style:
                                  bodyTextStyle.copyWith(color: context.colors.textSecondary),
                            ),
                          );
                        }
                      },
                      loading: () {
                        return const Center(child: CircularProgressIndicator());
                      },
                      error: (error, stack) => Center(
                        child: Text(
                          'Error: $error',
                          style: bodyTextStyle.copyWith(color: errorColor),
                        ),
                      ),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Category Carousel Card
class CategoryCarouselCard extends ConsumerWidget {
  final Category category;
  final bool isSelected;

  const CategoryCarouselCard(
    this.category, {
    super.key,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CarouselCard(
      imageUrl: category.imageUrl,
      title: category.name,
      backgroundColor: Colors.white,
      imagePadding: const EdgeInsets.all(16.0),
      imageFit: BoxFit.contain,
      onTap: () {
        ref.read(selectedCategoriesProvider.notifier).state = category.id;
        ref.read(bottomNavigationBarProvider.notifier).state =
            NavigationItem.search;
      },
    );
  }
}
