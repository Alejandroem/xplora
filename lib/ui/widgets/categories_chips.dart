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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          runAlignment: WrapAlignment.start,
          direction: Axis.horizontal,
          spacing: 8.0,
          runSpacing: 8.0,
          children: categories.asMap().entries.map((entry) {
            final category = entry.value;
            final isSelected = selectedCategories.contains(category);

            return ChoiceChip(
              showCheckmark: false,
              selected: isSelected,
              onSelected: (bool selected) {
                // Update the selected categories based on the user's selection
                final updatedCategories = List<String>.from(selectedCategories);
                if (selected) {
                  updatedCategories.add(category);
                } else {
                  updatedCategories.remove(category);
                }
                ref.read(selectedCategoriesProvider.notifier).state =
                    updatedCategories;
              },
              backgroundColor: isSelected ? raisingBlack : Colors.white,
              padding: const EdgeInsets.all(0.0),
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : raisingBlack,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
