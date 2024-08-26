import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/xplora_profile_service.dart';
import '../../infrastructure/services/firebase_xplora_profile_service.dart';

final profileServiceProvider = Provider<XploraProfileService>((ref) {
  return FirebaseXploraProfileCrudService();
});
