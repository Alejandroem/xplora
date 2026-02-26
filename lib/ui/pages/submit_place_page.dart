import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/providers/category_providers.dart';
import '../../domain/models/place.dart';
import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/xplora_text_field.dart';
import '../widgets/secondary_button.dart';
import '../widgets/category_selection_bottom_sheet.dart';
import '../dialogs/base_dialog.dart';
import 'drop_pin_map_page.dart';

/// Provider to manage the list of selected images for place submission.
final selectedPlaceImagesProvider =
    StateProvider.autoDispose<List<String>>((ref) => []);

/// Provider to manage all category selections (parentId → selectedChildId)
final categorySelectionsProvider =
    StateProvider.autoDispose<Map<String, String?>>((ref) => {});

/// Model to store selected location data
class SelectedLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeName;

  SelectedLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeName,
  });

  String get displayText {
    if (placeName != null && placeName!.isNotEmpty) {
      return placeName!;
    }
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }
}

/// Provider to manage the selected location for place submission.
final selectedLocationProvider =
    StateProvider.autoDispose<SelectedLocation?>((ref) => null);

/// Screen where users can submit a new place to the platform.
/// Users can help improve the map and earn XP by contributing places.
class SubmitPlacePage extends ConsumerStatefulWidget {
  const SubmitPlacePage({super.key});

  @override
  ConsumerState<SubmitPlacePage> createState() => _SubmitPlacePageState();
}

class _SubmitPlacePageState extends ConsumerState<SubmitPlacePage> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _placeNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  static const int _maxImages = 4;

  @override
  void dispose() {
    _placeNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceDialog() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.bgTertiary,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(radiusCard)),
          border: Border(
            top: BorderSide(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
        ),
        padding: const EdgeInsets.all(spacing24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Photo',
              style: h3Style.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: spacing24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: spacing16),
          ],
        ),
      ),
    );
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: spacing12,
          horizontal: spacing16,
        ),
        decoration: BoxDecoration(
          color: context.colors.bgSecondary,
          borderRadius: BorderRadius.circular(radiusMedium),
          border: Border.all(
            color: context.colors.border,
            width: borderWidthDefault,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: context.colors.textPrimary,
              size: iconSizeLarge,
            ),
            const SizedBox(height: spacing8),
            Text(
              label,
              style: bodySmallStyle.copyWith(
                color: context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final images = ref.read(selectedPlaceImagesProvider);
    if (images.length >= _maxImages) return;

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        ref.read(selectedPlaceImagesProvider.notifier).state = [
          ...images,
          image.path,
        ];
      }
    } catch (e) {
      print(e);
      if (mounted) {
        showXploraSnackBar(context, 'Error picking image: $e', isError: true);
      }
    }
  }

  void _removeImage(int index) {
    final images = ref.read(selectedPlaceImagesProvider);
    final newImages = List<String>.from(images)..removeAt(index);
    ref.read(selectedPlaceImagesProvider.notifier).state = newImages;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final selectedImages = ref.watch(selectedPlaceImagesProvider);
    final canAddMore = selectedImages.length < _maxImages;

    return GradientBackground(
      child: Scaffold(
        appBar: const GlassAppBar(
          title: 'Submit a Place',
          centerTitle: true,
          height: 64,
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Upload Section
                _buildImageUploadSection(selectedImages, canAddMore),

                const SizedBox(height: spacing24),

                // Form Fields Section
                _buildFormFieldsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection(List<String> images, bool canAddMore) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        0,
        spacing16,
        images.isEmpty ? spacing16 : 0,
        0,
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          children: [
            // Plus button (visible until 4 images are added)
            if (canAddMore) ...[
              Padding(
                padding: const EdgeInsets.only(left: spacing16),
                child: _buildAddImageButton(),
              ),
              const SizedBox(width: spacing12),
            ],
            // Image containers
            Expanded(
              child: images.isEmpty
                  ? _buildPlaceholderContainer()
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(width: spacing12),
                      itemBuilder: (context, index) {
                        final isFirst = index == 0;
                        final isLast = index == images.length - 1;
                        return Padding(
                          padding: EdgeInsets.only(
                            left: isFirst && !canAddMore ? spacing16 : 0,
                            right: isLast ? spacing16 : 0,
                          ),
                          child: _buildImageContainer(images[index], index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddImageButton() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/svg/grey-plus.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(context.colors.textPrimary, BlendMode.srcIn),
            ),
          )),
    );
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusMedium),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(spacing8),
          child: Text(
            'Your photos will appear here',
            textAlign: TextAlign.center,
            style: bodySmallStyle.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(String imagePath, int index) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radiusMedium),
            child: Image.file(
              File(imagePath),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.error_outline,
                  color: errorColor,
                  size: iconSizeLarge,
                ),
              ),
            ),
          ),
        ),
        // Remove button
        Positioned(
          top: spacing4,
          right: spacing4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: iconSizeMedium,
              height: iconSizeMedium,
              decoration: BoxDecoration(
                color: blackClr.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: iconSizeSmall,
                color: whiteClr,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormFieldsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place Name Field
          XploraTextField(
            controller: _placeNameController,
            labelText: 'Place Name',
            hintText: 'Enter the place name',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            maxLength: 100,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Place name is required';
              }
              if (value.trim().length < 3) {
                return 'Place name must be at least 3 characters';
              }
              if (value.trim().length > 100) {
                return 'Place name must not exceed 100 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: spacing24),

          // Description Field
          XploraTextField(
            controller: _descriptionController,
            labelText: 'Description',
            hintText: 'Describe this place...',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 5,
            maxLength: 500,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              if (value.trim().length < 10) {
                return 'Description must be at least 10 characters';
              }
              if (value.trim().length > 500) {
                return 'Description must not exceed 500 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: spacing24),

          // Location and Category Section
          _buildLocationCategorySection(),

          const SizedBox(height: spacing24),

          // Submit Button
          PrimaryButton(
            text: 'Submit Place',
            onPressed: _handleSubmit,
          ),

          const SizedBox(height: spacing16),

          // Review notice
          Text(
            'Your submission will be reviewed by XPLRA team.\nApproved places are rewarded XP.',
            textAlign: TextAlign.center,
            style: captionStyle.copyWith(
              color: context.colors.textSecondary.withValues(alpha: 0.5),
            ),
          ),

          const SizedBox(height: spacing24),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final selectedImages = ref.read(selectedPlaceImagesProvider);
    final selectedLocation = ref.read(selectedLocationProvider);
    final categorySelections = ref.read(categorySelectionsProvider);

    if (selectedImages.isEmpty) {
      showXploraSnackBar(context, 'Please add at least one image',
          isError: true);
      return;
    }

    if (selectedLocation == null) {
      showXploraSnackBar(context, 'Please select a location', isError: true);
      return;
    }

    final categories = await ref.read(placeCategoriesProvider.future);
    final selectedCategorySelections = categorySelections.entries
        .where((e) => e.value != null)
        .map((e) {
          final child = categories.firstWhere((c) => c.id == e.value);
          return CategorySelection(
            selectedId: child.id,
            path: [...child.ancestorIds, child.id],
          );
        })
        .toList();

    print('=== SUBMIT PLACE DATA ===');
    print('Place Name: ${_placeNameController.text}');
    print('Description: ${_descriptionController.text}');
    print('\nImages (${selectedImages.length}):');
    for (var i = 0; i < selectedImages.length; i++) {
      print('  Image ${i + 1}: ${selectedImages[i]}');
    }
    print('\nLocation:');
    print('  Latitude: ${selectedLocation.latitude}');
    print('  Longitude: ${selectedLocation.longitude}');
    print('  Address: ${selectedLocation.address ?? 'N/A'}');
    print('  Place Name: ${selectedLocation.placeName ?? 'N/A'}');
    print('\nCategories (${selectedCategorySelections.length}):');
    for (final s in selectedCategorySelections) {
      print('  selectedId: ${s.selectedId}, path: ${s.path}');
    }
    print('=== END SUBMIT DATA ===\n');

    // TODO: submit place with selectedCategorySelections
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Non-dismissible
      builder: (dialogContext) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // Back button was pressed, manually pop both dialog and page
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pop();
          }
        },
        child: BaseDialog(
          icon: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                  color: brandPrimary.withValues(alpha: 0.15),
                  borderRadius:
                      const BorderRadius.all(Radius.circular(radiusLarge)),
                  border: Border.all(
                      width: 2, color: brandPrimary.withValues(alpha: 0.3))),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svg/checkmark.svg',
                  width: 36,
                  height: 36,
                  colorFilter: ColorFilter.mode(brandPrimary, BlendMode.srcIn),
                ),
              )),
          title: 'Place Submitted!',
          description: 'You will receive XP once it\'s approved.',
          actions: [
            PrimaryButton(
              text: 'Back to quests',
              onPressed: () {
                // Close dialog
                Navigator.of(dialogContext).pop();
                // Close submit place page
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCategorySelectionBottomSheet() async {
    final categories = await ref.read(placeCategoriesProvider.future);
    if (!mounted) return;

    final currentSelections = ref.read(categorySelectionsProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CategorySelectionBottomSheet(
        categories: categories,
        initialSelections: currentSelections,
        onSelectionChanged: (selections) {
          ref.read(categorySelectionsProvider.notifier).state = selections;
        },
      ),
    );

    FocusManager.instance.primaryFocus?.unfocus();
  }

  Widget _buildLocationCategorySection() {
    final selectedLocation = ref.watch(selectedLocationProvider);
    final categorySelections = ref.watch(categorySelectionsProvider);
    final selectedCount =
        categorySelections.values.where((v) => v != null).length;
    final categoriesAsync = ref.watch(placeCategoriesProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Location Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: spacing8),
              SecondaryButton(
                icon: SvgPicture.asset(
                  'assets/svg/location-pin.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                      context.colors.textPrimary, BlendMode.srcIn),
                ),
                text: selectedLocation == null ? 'Drop Pin' : 'Edit Pin',
                onPressed: () async {
                  final result = await Navigator.push<SelectedLocation>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DropPinMapPage(
                        initialLocation: selectedLocation,
                      ),
                    ),
                  );

                  FocusManager.instance.primaryFocus?.unfocus();

                  if (result != null) {
                    ref.read(selectedLocationProvider.notifier).state = result;
                  }
                },
              ),
              if (selectedLocation != null) ...[
                const SizedBox(height: spacing4),
                Text(
                  selectedLocation.displayText,
                  style: captionStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: spacing12),

        // Category Section
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: spacing8),
              SecondaryButton(
                text: 'Choose categories',
                onPressed: categoriesAsync.isLoading
                    ? null
                    : _showCategorySelectionBottomSheet,
              ),
              const SizedBox(height: spacing4),
              Text(
                selectedCount > 0
                    ? '$selectedCount ${selectedCount == 1 ? 'category' : 'categories'} selected'
                    : '',
                style: captionStyle.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
