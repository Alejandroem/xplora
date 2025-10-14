import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/auth_service.dart';
import '../../infrastructure/services/firebase_auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});
