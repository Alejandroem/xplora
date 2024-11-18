import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationItem { home, search, notifications }

final bottomNavigationBarProvider = StateProvider<NavigationItem>((ref) {
  return NavigationItem.home;
});
