import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../theme.dart';

class BottomAvatarSelectionCard extends StatefulWidget {
  final String? currentAvatarUrl;
  final String? selectedImagePath;
  final Function(String) onAvatarSelected;

  const BottomAvatarSelectionCard({
    super.key,
    this.currentAvatarUrl,
    this.selectedImagePath,
    required this.onAvatarSelected,
  });

  @override
  State<BottomAvatarSelectionCard> createState() => _BottomAvatarSelectionCardState();
}

class _BottomAvatarSelectionCardState extends State<BottomAvatarSelectionCard> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  String? _initialImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialImagePath = widget.selectedImagePath;
    _selectedImagePath = widget.selectedImagePath;
  }

  bool get _hasChanges {
    return _selectedImagePath != _initialImagePath;
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error picking image: $e',
              style: bodyTextStyle.copyWith(color: textPrimary),
            ),
            backgroundColor: errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _removeAvatar() {
    setState(() {
      _selectedImagePath = null;
    });
    widget.onAvatarSelected('');
    Navigator.of(context).pop();
  }

  void _confirmSelection() {
    if (_selectedImagePath != null) {
      widget.onAvatarSelected(_selectedImagePath!);
    } else {
      widget.onAvatarSelected('');
    }
    Navigator.of(context).pop();
  }

  Widget _buildFileImage(String filePath) {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        return Icon(
          Icons.add_a_photo,
          color: textSecondary,
          size: 40,
        );
      }

      return Image.file(
        file,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.add_a_photo,
            color: textSecondary,
            size: 40,
          );
        },
      );
    } catch (e) {
      return Icon(
        Icons.add_a_photo,
        color: textSecondary,
        size: 40,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgTertiary, // Solid background to prevent text interference
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: border,
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Select Avatar',
            style: h3Style,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          
          // Current/Selected Avatar Preview
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: bgSecondary,
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: border,
                  width: 2,
                ),
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: brandPrimary,
                      ),
                    )
                  : _selectedImagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: _buildFileImage(_selectedImagePath!),
                        )
                      : widget.currentAvatarUrl != null && widget.currentAvatarUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                widget.currentAvatarUrl!,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.add_a_photo,
                                    color: textSecondary,
                                    size: 40,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              color: textSecondary,
                              size: 40,
                            ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Selection Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOptionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () => _pickImage(ImageSource.camera),
              ),
              _buildOptionButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              if (widget.currentAvatarUrl != null && widget.currentAvatarUrl!.isNotEmpty)
                _buildOptionButton(
                  icon: Icons.delete,
                  label: 'Remove',
                  onTap: _removeAvatar,
                  isDestructive: true,
                ),
            ],
          ),
          const SizedBox(height: 24.0),
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  height: 50,
                  text: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: brandPrimary,
                        ),
                      )
                    : PrimaryButton(
                        height: 50,
                        text: 'Confirm',
                        onPressed: _hasChanges ? _confirmSelection : null,
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDestructive ? errorColor : border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDestructive ? errorColor : textPrimary,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: bodySmallStyle.copyWith(
                color: isDestructive ? errorColor : textPrimary
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showBottomAvatarSelectionCard({
  required BuildContext context,
  String? currentAvatarUrl,
  String? selectedImagePath,
  required Function(String) onAvatarSelected,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    isDismissible: true,
    context: context,
    backgroundColor: Colors.transparent, // Transparent to show custom background
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomAvatarSelectionCard(
          currentAvatarUrl: currentAvatarUrl,
          selectedImagePath: selectedImagePath,
          onAvatarSelected: onAvatarSelected,
        ),
      );
    },
  );
}
