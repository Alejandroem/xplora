import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import 'xplorauser_providers.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return FirebaseAuthService();
});

final profileStreamProvider = StreamProvider.autoDispose((ref) async* {
  final authService = ref.watch(authServiceProvider);
  final user = await authService.getAuthUser();
  final profileService = ref.watch(profileServiceProvider);
  if (user == null) {
    yield null;
  } else {
    yield* profileService.getStream(user.id!);
  }
});
