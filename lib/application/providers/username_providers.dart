import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/username_notifier.dart';
import 'auth_service_providers.dart';
import 'xplorauser_providers.dart';

final usernameNotifierProvider =
    StateNotifierProvider.autoDispose<UsernameNotifier, UsernameState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final userService = ref.watch(userServiceProvider);
  return UsernameNotifier(authService, userService);
});
