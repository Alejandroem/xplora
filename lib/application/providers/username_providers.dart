import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/username_notifier.dart';
import 'auth_service_providers.dart';

final usernameNotifierProvider =
    StateNotifierProvider.autoDispose<UsernameNotifier, UsernameState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UsernameNotifier(authService);
});
