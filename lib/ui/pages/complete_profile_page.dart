import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../application/providers/location_providers.dart';
import '../../domain/services/country_city_data_service.dart';
import '../../theme.dart';
import '../../application/providers/complete_profile_providers.dart';
import '../../utils/snackbar_utils.dart';
import '../dialogs/bottom_avatar_selection_card.dart';
import '../dialogs/first_session_dialog.dart';
import '../dialogs/location_permission_dialog.dart';
import '../widgets/custom_dropdown.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  ConsumerState<CompleteProfilePage> createState() =>
      _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  String? _selectedImagePath;
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  bool _isShowingDialog = false;
  final FocusNode _dummyFocusNode = FocusNode();

  // Memoize year list to avoid regenerating on every build
  late final List<String> _years = List.generate(
    100,
    (index) => (DateTime.now().year - 100 + index).toString(),
  );

  @override
  void initState() {
    super.initState();
    // Load countries and existing profile data (e.g., Google photo) using the notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(completeProfileFormNotifierProvider.notifier);
      notifier.loadCountries();
      notifier.loadExistingProfile();
    });
  }

  @override
  void dispose() {
    _countryFocusNode.dispose();
    _cityFocusNode.dispose();
    _usernameController.dispose();
    _dummyFocusNode.dispose();
    super.dispose();
  }

  final List<String> _languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
    'Hindi',
    'Russian',
  ];

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> _genders = [
    'Male',
    'Female',
    'Prefer not to say',
  ];

  final List<String> _interestCategories = [
    'Adventure & Outdoor',
    'Culture & History',
    'Food & Dining',
    'Nightlife & Entertainment',
    'Nature & Wildlife',
    'Sports & Fitness',
    'Art & Museums',
    'Music & Events',
    'Shopping',
    'Photography',
    'Wellness & Spa',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(completeProfileFormNotifierProvider);
        showFirstSessionDialogIfLocationEnabled(context, ref);
        return true;
      },
      child: Scaffold(
        appBar: const GlassAppBar(
          title: 'logo',
          centerTitle: true,
        ),
        body: Focus(
          focusNode: _dummyFocusNode,
          child: GradientBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Complete Profile title
                    Center(
                      child: Text(
                        'Complete Your Profile',
                        style: h1Style,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Center(
                      child: Text(
                        'Tell us more about yourself to personalize your experience',
                        style: bodyTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Username field
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        XploraTextField(
                          controller: _usernameController,
                          labelText: 'Handle',
                          hintText: 'Choose a unique handle',
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: context.colors.textSecondary,
                            size: 20,
                          ),
                          onChanged: (value) {
                            final trimmedValue = value.trim();
                            final profileNotifier = ref.read(
                                completeProfileFormNotifierProvider.notifier);
                            profileNotifier.setUsername(trimmedValue);

                            // Check username availability (debounced)
                            profileNotifier
                                .checkUsernameAvailability(trimmedValue);
                          },
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final username = ref.watch(
                              completeProfileFormNotifierProvider
                                  .select((state) => state.username),
                            );
                            final isCheckingUsername = ref.watch(
                              completeProfileFormNotifierProvider
                                  .select((state) => state.isCheckingUsername),
                            );
                            final isUsernameUnique = ref.watch(
                              completeProfileFormNotifierProvider
                                  .select((state) => state.isUsernameUnique),
                            );

                            if (username.isNotEmpty && username.length >= 6) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    if (isCheckingUsername)
                                      const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                      )
                                    else if (isUsernameUnique)
                                      Icon(
                                        Icons.check_circle,
                                        color: successColor,
                                        size: 16,
                                      )
                                    else
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    const SizedBox(width: 8),
                                    Text(
                                      isCheckingUsername
                                          ? 'Checking availability...'
                                          : isUsernameUnique
                                              ? 'Username is available'
                                              : 'Username is already taken',
                                      style: TextStyle(
                                        color: isCheckingUsername
                                            ? Colors.blue
                                            : isUsernameUnique
                                                ? successColor
                                                : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Avatar section (optional)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avatar (Optional)',
                          style: bodySmallStyle,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: GestureDetector(
                            onTap: () async {
                              final currentAvatarUrl = ref
                                  .read(completeProfileFormNotifierProvider)
                                  .avatarUrl;
                              // Request focus on dummy node to prevent text field focus
                              _dummyFocusNode.requestFocus();
                              await Future.delayed(
                                  const Duration(milliseconds: 100));
                              showBottomAvatarSelectionCard(
                                context: context,
                                currentAvatarUrl: currentAvatarUrl,
                                selectedImagePath: _selectedImagePath,
                                onAvatarSelected: (imagePath) {
                                  setState(() {
                                    _selectedImagePath = imagePath;
                                  });
                                  ref
                                      .read(completeProfileFormNotifierProvider
                                          .notifier)
                                      .setAvatarUrl(imagePath);
                                },
                              );
                            },
                            child: Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                color: context.colors.bgSecondary,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: context.colors.border,
                                  width: 2,
                                ),
                              ),
                              child: _selectedImagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        File(_selectedImagePath!),
                                        width: 130,
                                        height: 130,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(
                                            Icons.add_a_photo,
                                            color: context.colors.textSecondary,
                                            size: 40,
                                          );
                                        },
                                      ),
                                    )
                                  : _buildAvatarFromUrl(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),

                    // Preferred Language dropdown
                    Consumer(
                      builder: (context, ref, child) {
                        final preferredLanguage = ref.watch(
                          completeProfileFormNotifierProvider
                              .select((state) => state.preferredLanguage),
                        );
                        return CustomDropdown(
                          label: 'Preferred Language',
                          value: preferredLanguage,
                          items: _languages,
                          onChanged: (value) {
                            ref
                                .read(completeProfileFormNotifierProvider
                                    .notifier)
                                .setPreferredLanguage(value);
                          },
                          icon: Icons.language,
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Country and City fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildCountryDropdown(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCityDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Birthday fields
                    Text(
                      'Birthday',
                      style: bodySmallStyle
                    ),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, child) {
                        final birthdayMonth = ref.watch(
                          completeProfileFormNotifierProvider
                              .select((state) => state.birthdayMonth),
                        );
                        final birthdayYear = ref.watch(
                          completeProfileFormNotifierProvider
                              .select((state) => state.birthdayYear),
                        );
                        return Row(
                          children: [
                            Expanded(
                              child: CustomDropdown(
                                label: 'Month',
                                value: birthdayMonth,
                                items: _months,
                                onChanged: (value) {
                                  ref
                                      .read(completeProfileFormNotifierProvider
                                          .notifier)
                                      .setBirthdayMonth(value);
                                },
                                icon: Icons.calendar_month,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomDropdown(
                                label: 'Year',
                                value: birthdayYear,
                                items: _years,
                                onChanged: (value) {
                                  ref
                                      .read(completeProfileFormNotifierProvider
                                          .notifier)
                                      .setBirthdayYear(value);
                                },
                                icon: Icons.calendar_today,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Gender dropdown (optional)
                    Consumer(
                      builder: (context, ref, child) {
                        final gender = ref.watch(
                          completeProfileFormNotifierProvider
                              .select((state) => state.gender),
                        );
                        return CustomDropdown(
                          label: 'Gender (Optional)',
                          value: gender,
                          items: _genders,
                          onChanged: (value) {
                            ref
                                .read(completeProfileFormNotifierProvider
                                    .notifier)
                                .setGender(value);
                          },
                          icon: Icons.person,
                          isOptional: true,
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // Primary Interest Category dropdown
                    Consumer(
                      builder: (context, ref, child) {
                        final primaryInterestCategory = ref.watch(
                          completeProfileFormNotifierProvider
                              .select((state) => state.primaryInterestCategory),
                        );
                        return CustomDropdown(
                          label: 'Primary Interest Category',
                          value: primaryInterestCategory,
                          items: _interestCategories,
                          onChanged: (value) {
                            ref
                                .read(completeProfileFormNotifierProvider
                                    .notifier)
                                .setPrimaryInterestCategory(value);
                          },
                          icon: Icons.favorite,
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Complete Profile button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Consumer(
                        builder: (ctx, ref, child) {
                          final isLoading = ref.watch(
                            completeProfileFormNotifierProvider
                                .select((state) => state.isLoading),
                          );
                          final isButtonLoading = isLoading || _isShowingDialog;

                          return PrimaryButton(
                            text: isButtonLoading
                                ? 'Completing profile...'
                                : 'Complete profile',
                            onPressed: isButtonLoading
                                ? null
                                : () async {
                                    final profileNotifier = ref.read(
                                        completeProfileFormNotifierProvider
                                            .notifier);
                                    final profileState = ref.read(
                                        completeProfileFormNotifierProvider);

                                    // Check if username is unique (only if username was entered and is valid)
                                    if (profileState.username.isNotEmpty &&
                                        profileState.username.length >= 6 &&
                                        !profileState.isUsernameUnique) {
                                      showXploraSnackBar(
                                        context,
                                        'Username is already taken',
                                        isError: true,
                                      );
                                      return;
                                    }

                                    // Perform profile completion
                                    await profileNotifier.completeProfile();

                                    // Check for errors
                                    final finalState = ref.read(
                                        completeProfileFormNotifierProvider);
                                    if (finalState.errors.isNotEmpty) {
                                      if (context.mounted) {
                                        showXploraSnackBar(
                                          context,
                                          finalState.errors.first,
                                          isError: true,
                                        );
                                      }
                                    } else {
                                      // Success - show location permission dialog
                                      if (context.mounted) {
                                        // Set dialog loading state
                                        setState(() {
                                          _isShowingDialog = true;
                                        });

                                        // Show location permission dialog
                                        await showLocationPermissionDialog(
                                            context);

                                        // Clear state after dialog closes
                                        if (mounted) {
                                          setState(() {
                                            _isShowingDialog = false;
                                          });
                                          ref.invalidate(
                                              completeProfileFormNotifierProvider);

                                          // Navigate to categories
                                          Navigator.pushReplacementNamed(
                                              context, '/categories');
                                        }
                                      }
                                    }
                                  },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFromUrl() {
    return Consumer(
      builder: (context, ref, child) {
        final avatarUrl = ref.watch(
          completeProfileFormNotifierProvider
              .select((state) => state.avatarUrl),
        );

        if (avatarUrl.isEmpty) {
          return Icon(
            Icons.add_a_photo,
            color: context.colors.textSecondary,
            size: 40,
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: avatarUrl.startsWith('http')
              ? Image.network(
                  avatarUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.add_a_photo,
                      color: context.colors.textSecondary,
                      size: 40,
                    );
                  },
                )
              : _buildFileImage(avatarUrl),
        );
      },
    );
  }

  Widget _buildFileImage(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return Icon(
          Icons.add_a_photo,
          color: context.colors.textSecondary,
          size: 40,
        );
      }

      return Image.file(
        file,
        width: 130,
        height: 130,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.add_a_photo,
            color: context.colors.textSecondary,
            size: 40,
          );
        },
      );
    } catch (e) {
      return Icon(
        Icons.add_a_photo,
        color: context.colors.textSecondary,
        size: 40,
      );
    }
  }

  Widget _buildSearchableDropdown<T extends Object>({
    required String label,
    required String hintText,
    required IconData icon,
    required List<T> items,
    required String Function(T) displayStringForOption,
    required String selectedValue,
    required void Function(T) onSelected,
    required void Function() onClear,
    required bool enabled,
    bool clearOnEmpty = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: bodySmallStyle
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Autocomplete<T>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (!enabled || items.isEmpty) {
                  return const Iterable<Never>.empty();
                }
                if (textEditingValue.text.isEmpty) {
                  return items.take(50);
                }
                return items.where((T item) {
                  return displayStringForOption(item)
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).take(50);
              },
              displayStringForOption: displayStringForOption,
              onSelected: onSelected,
              optionsMaxHeight: 200,
              optionsViewBuilder: (context, onSelectedOption, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: context.colors.bgTertiary,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth,
                        maxHeight: 200,
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final item = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelectedOption(item),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: context.colors.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      displayStringForOption(item),
                                      style: bodyTextStyle.copyWith(
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              fieldViewBuilder:
                  (context, textController, focusNode, onFieldSubmitted) {
                // Sync the text controller with selected value
                if (selectedValue.isNotEmpty &&
                    textController.text != selectedValue) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    textController.text = selectedValue;
                  });
                } else if (clearOnEmpty &&
                    selectedValue.isEmpty &&
                    textController.text.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    textController.clear();
                  });
                }

                return XploraTextField(
                  textCapitalization: TextCapitalization.words,
                  // onTapOutside: (event) {
                  //   focusNode.unfocus();
                  // },
                  onTapOutside: (event) => {},
                  controller: textController,
                  focusNode: focusNode,
                  enabled: enabled,
                  hintText: hintText,
                  prefixIcon: Icon(
                    icon,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                  style: bodyTextStyle.copyWith(
                    color: context.colors.textPrimary,
                    fontSize: 15,
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: context.colors.textSecondary,
                    size: 20,
                  ),
                  onChanged: (value) {
                    if (selectedValue.isNotEmpty && value != selectedValue) {
                      onClear();
                    }
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildCountryDropdown() {
    return Consumer(
      builder: (context, ref, child) {
        final profileState = ref.watch(completeProfileFormNotifierProvider);
        final isLoading = profileState.isLoadingCountries;

        return _buildSearchableDropdown<Country>(
          label: 'Country',
          hintText: isLoading ? 'Loading...' : 'Search country...',
          icon: Icons.flag,
          items: profileState.countries,
          displayStringForOption: (country) => country.name,
          selectedValue: profileState.country,
          onSelected: (country) {
            ref
                .read(completeProfileFormNotifierProvider.notifier)
                .selectCountry(country.name);
            FocusScope.of(context).unfocus();
          },
          onClear: () {
            ref
                .read(completeProfileFormNotifierProvider.notifier)
                .setCountry('');
          },
          enabled: !isLoading,
        );
      },
    );
  }

  Widget _buildCityDropdown() {
    return Consumer(
      builder: (context, ref, child) {
        final profileState = ref.watch(completeProfileFormNotifierProvider);
        final isCountrySelected = profileState.country.isNotEmpty;
        final hasCities = profileState.cities.isNotEmpty;
        final isLoadingCities = profileState.isLoadingCities;

        String hintText;
        if (!isCountrySelected) {
          hintText = 'Select Country First';
        } else if (isLoadingCities) {
          hintText = 'Loading cities...';
        } else if (!hasCities) {
          hintText = 'No Cities Available';
        } else {
          hintText = 'Search city...';
        }

        return _buildSearchableDropdown<City>(
          label: 'City',
          hintText: hintText,
          icon: Icons.location_city,
          items: profileState.cities,
          displayStringForOption: (city) => city.name,
          selectedValue: profileState.city,
          onSelected: (city) {
            ref
                .read(completeProfileFormNotifierProvider.notifier)
                .setCity(city.name);
            FocusScope.of(context).unfocus();
          },
          onClear: () {
            ref.read(completeProfileFormNotifierProvider.notifier).setCity('');
          },
          enabled: isCountrySelected && !isLoadingCities && hasCities,
          clearOnEmpty: true,
        );
      },
    );
  }
}
