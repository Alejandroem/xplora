import 'dart:io';
import 'package:image_picker/image_picker.dart';

/// Exception thrown when image picking fails
class ImagePickerException implements Exception {
  final String message;
  final dynamic originalError;

  ImagePickerException(this.message, [this.originalError]);

  @override
  String toString() => 'ImagePickerException: $message';
}

/// Model for picked image result
class PickedImageResult {
  final File file;
  final String path;
  final String name;
  final int sizeInBytes;
  final double sizeInMB;
  final String? mimeType;

  PickedImageResult({
    required this.file,
    required this.path,
    required this.name,
    required this.sizeInBytes,
    required this.sizeInMB,
    this.mimeType,
  });

  @override
  String toString() {
    return '''
📸 ========== Image Details ==========
Path: $path
Name: $name
Size: ${sizeInMB.toStringAsFixed(2)} MB ($sizeInBytes bytes)
MIME Type: $mimeType
====================================''';
  }
}

/// Service for handling image picking and compression
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Retrieve lost data after MainActivity destruction (Android only)
  ///
  /// **NOTE: Currently not in use - reserved for future if issues occur**
  ///
  /// Call this method when the app starts to recover images that were
  /// selected before Android killed the MainActivity due to low memory.
  ///
  /// To enable: Uncomment usage in profile_page.dart
  ///
  /// Returns [PickedImageResult] if data was recovered, null otherwise
  Future<PickedImageResult?> retrieveLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();

      if (response.isEmpty) {
        print('ℹ️ No lost data to retrieve');
        return null;
      }

      // Handle error during retrieval
      if (response.exception != null) {
        print('❌ Error retrieving lost data: ${response.exception}');
        throw ImagePickerException(
          'Failed to retrieve lost data',
          response.exception,
        );
      }

      // Get the files (usually only one for single image pick)
      final List<XFile>? files = response.files;
      if (files == null || files.isEmpty) {
        print('ℹ️ Lost data retrieved but no files found');
        return null;
      }

      // Process the first file (we only pick single images)
      final XFile image = files.first;
      final File imageFile = File(image.path);

      if (!await imageFile.exists()) {
        throw ImagePickerException('Retrieved image file does not exist');
      }

      final int fileSize = await imageFile.length();
      final double fileSizeInMB = fileSize / (1024 * 1024);

      final result = PickedImageResult(
        file: imageFile,
        path: image.path,
        name: image.name,
        sizeInBytes: fileSize,
        sizeInMB: fileSizeInMB,
        mimeType: image.mimeType,
      );

      print('📸 Recovered lost data:');
      print(result.toString());

      return result;
    } catch (e) {
      print('❌ Error in retrieveLostData: $e');
      if (e is ImagePickerException) rethrow;
      throw ImagePickerException('Failed to retrieve lost data', e);
    }
  }

  /// Pick image from gallery with automatic compression
  ///
  /// [maxWidth] and [maxHeight] resize the image while maintaining aspect ratio
  /// [imageQuality] compresses the image (0-100, default 85)
  ///
  /// Returns [PickedImageResult] if successful, null if user cancels
  /// Throws [ImagePickerException] on error
  Future<PickedImageResult?> pickImageFromGallery({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (image == null) {
        // User cancelled - not an error
        print('ℹ️ User cancelled image selection');
        return null;
      }

      // Get file details
      final File imageFile = File(image.path);

      // Check if file exists
      if (!await imageFile.exists()) {
        throw ImagePickerException('Selected image file does not exist');
      }

      final int fileSize = await imageFile.length();

      // Validate file size (max 10MB)
      if (fileSize > 10 * 1024 * 1024) {
        throw ImagePickerException(
          'Image too large. Maximum size is 10MB. Selected: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB'
        );
      }

      final double fileSizeInMB = fileSize / (1024 * 1024);

      final result = PickedImageResult(
        file: imageFile,
        path: image.path,
        name: image.name,
        sizeInBytes: fileSize,
        sizeInMB: fileSizeInMB,
        mimeType: image.mimeType,
      );

      // Print details for debugging
      print(result.toString());

      return result;
    } on ImagePickerException {
      // Re-throw our custom exceptions
      rethrow;
    } catch (e) {
      // Handle platform-specific errors
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('permission')) {
        throw ImagePickerException(
          'Gallery permission denied. Please enable photo library access in settings.',
          e,
        );
      } else if (errorMessage.contains('not available')) {
        throw ImagePickerException(
          'Gallery is not available on this device.',
          e,
        );
      } else {
        throw ImagePickerException(
          'Failed to pick image from gallery.',
          e,
        );
      }
    }
  }

  /// Pick image from camera with automatic compression
  ///
  /// Returns [PickedImageResult] if successful, null if user cancels
  /// Throws [ImagePickerException] on error
  Future<PickedImageResult?> pickImageFromCamera({
    int maxWidth = 1024,
    int maxHeight = 1024,
    int imageQuality = 85,
  }) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (image == null) {
        // User cancelled - not an error
        print('ℹ️ User cancelled camera capture');
        return null;
      }

      final File imageFile = File(image.path);

      // Check if file exists
      if (!await imageFile.exists()) {
        throw ImagePickerException('Captured image file does not exist');
      }

      final int fileSize = await imageFile.length();

      // Validate file size (max 10MB)
      if (fileSize > 10 * 1024 * 1024) {
        throw ImagePickerException(
          'Image too large. Maximum size is 10MB. Captured: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB'
        );
      }

      final double fileSizeInMB = fileSize / (1024 * 1024);

      final result = PickedImageResult(
        file: imageFile,
        path: image.path,
        name: image.name,
        sizeInBytes: fileSize,
        sizeInMB: fileSizeInMB,
        mimeType: image.mimeType,
      );

      print(result.toString());

      return result;
    } on ImagePickerException {
      // Re-throw our custom exceptions
      rethrow;
    } catch (e) {
      // Handle platform-specific errors
      final errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('permission')) {
        throw ImagePickerException(
          'Camera permission denied. Please enable camera access in settings.',
          e,
        );
      } else if (errorMessage.contains('not available')) {
        throw ImagePickerException(
          'Camera is not available on this device.',
          e,
        );
      } else {
        throw ImagePickerException(
          'Failed to capture image from camera.',
          e,
        );
      }
    }
  }
}
