import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/filters_providers.dart';
import '../../theme.dart';
import '../widgets/filter_bubble.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/gradient_background.dart';
import '../widgets/secondary_button.dart';

class FiltersPage extends ConsumerWidget {
  const FiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtersState = ref.watch(filtersStateProvider);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GlassAppBar(
          title: 'Filters',
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      'What do you want to explore?',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
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
                    FilterBubble(
                      text: 'All',
                      icon: Icon(
                        Icons.all_inclusive,
                        size: 20,
                        color: context.colors.textPrimary,
                      ),
                      isSelected: filtersState.selectedType == 'All',
                      onTap: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(
                          selectedType: 'All',
                        );
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    FilterBubble(
                      text: 'Adventure',
                      icon: Icon(
                        Icons.explore,
                        size: 20,
                        color: context.colors.textPrimary,
                      ),
                      isSelected: filtersState.selectedType == 'Adventure',
                      onTap: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(selectedType: 'Adventure');
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    FilterBubble(
                      text: 'Quest',
                      icon: Icon(
                        Icons.flag,
                        size: 20,
                        color: context.colors.textPrimary,
                      ),
                      isSelected: filtersState.selectedType == 'Quest',
                      onTap: () {
                        ref.read(filtersStateProvider.notifier).state =
                            filtersState.copyWith(selectedType: 'Quest');
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'How far do you want to travel?',
                        style: h3Style.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Icon(
                        Icons.location_on,
                        color: context.colors.iconColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          Slider(
                            value: filtersState.minimumDistance.toDouble(),
                            min: 1000,
                            max: 500000,
                            divisions: 100,
                            activeColor: brandPrimary,
                            inactiveColor: context.colors.border,
                            onChanged: (value) {
                              ref.read(filtersStateProvider.notifier).state =
                                  filtersState.copyWith(
                                      minimumDistance: value.round());
                            },
                          ),
                          Text(
                            '${(filtersState.minimumDistance / 1000).round()} km',
                            style: bodyTextStyle.copyWith(
                              color: context.colors.textPrimary,
                              fontWeight: FontWeight.bold,
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
                    Text(
                      'Which category interests you?',
                      style: h3Style.copyWith(
                        color: context.colors.textPrimary,
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
                            return Theme(
                              data: ThemeData(
                                colorScheme: ColorScheme.dark(
                                  primary: brandPrimary,
                                  secondary: brandPrimary,
                                  onPrimary: context.colors.textPrimary,
                                  onSecondary: context.colors.textPrimary,
                                ),
                              ),
                              child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  FilterBubble(
                                    text: 'All',
                                    icon: Icon(
                                      Icons.category_outlined,
                                      size: 20,
                                      color: context.colors.textPrimary,
                                    ),
                                    isSelected: ref.watch(selectedCategoriesProvider) == '',
                                    onTap: () {
                                      ref
                                          .read(selectedCategoriesProvider
                                              .notifier)
                                          .state = '';
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    fontSize: 12,
                                  ),
                                ...categories
                                    .where((c) => c.id != 'All')
                                    .map((category) {
                                  return FilterBubble(
                                    text: category.name,
                                    icon: Image.network(
                                      category.imageUrl,
                                      height: 20,
                                      width: 20,
                                      color: context.colors.textPrimary,
                                    ),
                                    isSelected: ref.watch(selectedCategoriesProvider) == category.id,
                                    onTap: () {
                                      ref
                                          .read(selectedCategoriesProvider
                                              .notifier)
                                          .state = category.id;
                                    },
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    fontSize: 12,
                                  );
                                }),
                              ],
                            ),
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
                SecondaryButton(
                  text: 'Clear Filters',
                  onPressed: () {
                    ref.read(selectedCategoriesProvider.notifier).state = '';
                    ref.read(filtersStateProvider.notifier).state =
                        filtersState.copyWith(
                      selectedType: 'All',
                      minimumDistance: 500000,
                    );
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }
}
