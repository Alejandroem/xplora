import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/constants.dart';
import '../../application/providers/local_storage_providers.dart';
import '../../theme.dart';

class ChooseCategories extends ConsumerStatefulWidget {
  const ChooseCategories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseCategoriesState();
}

class _ChooseCategoriesState extends ConsumerState<ChooseCategories> {
  List<String> selectedCategories = [];
  double chipOpacity = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          chipOpacity = 1;
        });
      });
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Categories where you want to explore Quests',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 32,
                  color: springBud,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                return AnimatedOpacity(
                  opacity: chipOpacity,
                  duration: Duration(milliseconds: index * 500),
                  curve: Curves.easeIn,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedCategories.contains(category)) {
                          selectedCategories.remove(category);
                        } else {
                          selectedCategories.add(category);
                        }
                      });
                    },
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                        side: BorderSide(
                          color: selectedCategories.contains(category)
                              ? Colors.white
                              : Colors.blue.shade100,
                        ),
                      ),
                      label: Text(category),
                      backgroundColor: selectedCategories.contains(category)
                          ? Colors.blue
                          : Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final localStorage = ref.read(localStorageProvider);
                //final profileService = ref.read(profileServiceProvider);

                //TODO tie this to a user anonymous id
                /* await profileService.create(
                  XploraProfile(categories: categories),
                ); */

                await localStorage.save(
                  kHasSelectedInitialCategoriesKey,
                  'true',
                );

                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save Categories',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: springBud,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
