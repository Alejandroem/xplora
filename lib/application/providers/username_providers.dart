import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/username_notifier.dart';

final usernameNotifierProvider =
    StateNotifierProvider.autoDispose<UsernameNotifier, UsernameState>((ref) {
  return UsernameNotifier();
});
