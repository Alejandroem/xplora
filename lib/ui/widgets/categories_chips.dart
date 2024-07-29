import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/constants.dart';
import '../../theme.dart';

class CategoriesChips extends ConsumerStatefulWidget {
  const CategoriesChips({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesChipsState();
}

class _CategoriesChipsState extends ConsumerState<CategoriesChips> {
  @override
  Widget build(BuildContext context) {
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
            final index = entry.key;
            final category = entry.value;
            return Chip(
              backgroundColor: raisingBlack,
              label: Text(
                category,
                style: TextStyle(
                  color: springBud,
                ),
              ),
              onDeleted: () {
                setState(() {
                  categories.removeAt(index);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
