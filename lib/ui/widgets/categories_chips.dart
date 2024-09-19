import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/adventure_providers.dart';
import '../../infrastructure/constants.dart';
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
    final selectedCategories = ref.watch(selectedCategoriesProvider);

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
                final isSelected = selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                    showCheckmark: false,
                    selected: isSelected,
                    onSelected: (bool selected) {
                      // Update the selected categories based on the user's selection
                      final updatedCategories =
                          List<String>.from(selectedCategories);
                      if (selected) {
                        updatedCategories.add(category);
                      } else {
                        updatedCategories.remove(category);
                      }
                      ref.read(selectedCategoriesProvider.notifier).state =
                          updatedCategories;
                    },
                    backgroundColor: isSelected ? raisingBlack : Colors.white,
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : raisingBlack,
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
                final isSelected = selectedCategories.contains(category);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64),
                    ),
                    showCheckmark: false,
                    selected: isSelected,
                    onSelected: (bool selected) {
                      // Update the selected categories based on the user's selection
                      final updatedCategories =
                          List<String>.from(selectedCategories);
                      if (selected) {
                        updatedCategories.add(category);
                      } else {
                        updatedCategories.remove(category);
                      }
                      ref.read(selectedCategoriesProvider.notifier).state =
                          updatedCategories;
                    },
                    backgroundColor: isSelected ? raisingBlack : Colors.white,
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : raisingBlack,
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
  }
}
