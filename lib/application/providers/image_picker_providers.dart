import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/image_picker_service.dart';

/// Provider for ImagePickerService
final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService();
});
