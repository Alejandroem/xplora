import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/services/firebase_storage_service.dart';
import '../../domain/services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return FirebaseStorageService();
});
