import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme.dart';
import '../../utils/snackbar_utils.dart';
import '../widgets/xplora_text_field.dart';
import '../widgets/secondary_button.dart';
import 'drop_pin_map_page.dart';

/// Provider to manage the list of selected images for place submission.
final selectedPlaceImagesProvider =
    StateProvider.autoDispose<List<String>>((ref) => []);

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
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.bgTertiary,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.colors.bgTertiary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(radiusCard)),
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
      padding: EdgeInsets.fromLTRB(0, spacing16,
          images.isEmpty ? spacing16 : 0, spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: spacing16),
          SizedBox(
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
          const SizedBox(height: spacing16),
        ],
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
        child: Icon(
          Icons.add,
          size: iconSizeLarge,
          color: context.colors.textSecondary,
        ),
      ),
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
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeImage(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: blackClr.withOpacity(0.6),
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
            hintText: 'Enter the name of the place',
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Place name is required';
              }
              if (value.trim().length < 3) {
                return 'Place name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: spacing24),

          // Description Field
          XploraTextField(
            controller: _descriptionController,
            labelText: 'Description',
            hintText: 'Describe this place and what makes it special',
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              if (value.trim().length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: spacing24),

          // Location and Category Section
          _buildLocationCategorySection(),
        ],
      ),
    );
  }

  Widget _buildLocationCategorySection() {
    final selectedLocation = ref.watch(selectedLocationProvider);

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
                text: selectedLocation == null ? 'Drop Pin' : 'Edit Pin',
                icon: Icon(
                  Icons.location_pin,
                  size: iconSizeMedium,
                  color: context.colors.textPrimary,
                ),
                onPressed: () async {
                  final result = await Navigator.push<SelectedLocation>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DropPinMapPage(
                        initialLocation: selectedLocation,
                      ),
                    ),
                  );

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
                'Category',
                style: bodySmallStyle.copyWith(
                  color: context.colors.textPrimary,
                ),
              ),
              const SizedBox(height: spacing8),
              SecondaryButton(
                text: 'Choose category',
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: iconSizeMedium,
                  color: context.colors.textPrimary,
                ),
                onPressed: () {
                  // TODO: Implement category selection
                  showXploraSnackBar(
                    context,
                    'Category selection coming soon',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
