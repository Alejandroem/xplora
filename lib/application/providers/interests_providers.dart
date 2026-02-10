import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/interests_notifier.dart';
import 'auth_service_providers.dart';
import 'profile_providers.dart';

final interestsNotifierProvider =
    StateNotifierProvider.autoDispose<InterestsNotifier, InterestsState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final profileService = ref.watch(profileServiceProvider);
  return InterestsNotifier(authService, profileService);
});
