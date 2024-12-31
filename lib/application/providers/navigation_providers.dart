import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationItem { home, search, XPC, store, notifications }

final bottomNavigationBarProvider = StateProvider<NavigationItem>((ref) {
  return NavigationItem.home;
});
