import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/category_providers.dart';
import '../../application/providers/profile_providers.dart';
import '../../infrastructure/constants.dart';
import '../../application/providers/local_storage_providers.dart';
import '../../infrastructure/services/firebase_auth_service.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';

class ChooseCategories extends ConsumerStatefulWidget {
  const ChooseCategories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseCategoriesState();
}

class _ChooseCategoriesState extends ConsumerState<ChooseCategories> {
  List<String> selectedCategories = [];
  double chipOpacity = 0;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        chipOpacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlassAppBar(title: 'logo', centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Choose interests for personalized feed and quest recommendations',
                textAlign: TextAlign.center, style: h2Style),
            const SizedBox(height: 22),
            ref.watch(allCategories).when(
                  data: (categories) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: categories.asMap().entries.map((entry) {
                        final index = entry.key;
                        final category = entry.value;
                        return AnimatedOpacity(
                          opacity: chipOpacity,
                          duration: Duration(milliseconds: index * 200),
                          curve: Curves.easeIn,
                          child: FilterBubble(
                            onTap: () {
                              setState(() {
                                if (selectedCategories.contains(category.id)) {
                                  selectedCategories.remove(category.id);
                                } else {
                                  selectedCategories.add(category.id);
                                }
                              });
                            },
                            text: category.name,
                            isSelected:
                                selectedCategories.contains(category.id),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, _) => Text('Error: $error'),
                ),
            const SizedBox(height: 32),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.3,
              child: SecondaryButton(
                onPressed: _isLoading || selectedCategories.isEmpty ? null : () async {
                  final localStorage = ref.read(localStorageProvider);
                  // final profileService = ref.read(profileServiceProvider);

                  //TODO tie this to a user anonymous id
                  /* await profileService.create(
                    XploraProfile(categories: categories),
                  ); */

                  setState(() {
                    _isLoading = true;
                  });

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('profile')
                      .doc('data')
                      .update({'categories': selectedCategories});

                  await localStorage.save(
                    kHasSelectedInitialCategoriesKey,
                    'true',
                  );

                  if (context.mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                    showXploraSnackBar(context, 'Interests saved successfully!');
                    // Navigator.of(context).pushReplacementNamed('/home');
                    Navigator.of(context).pop();
                  }
                },
                text: _isLoading ? 'Saving...' : 'Save',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
