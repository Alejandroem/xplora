import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/navigation_providers.dart';

class XploraBottomNavigationBar extends ConsumerStatefulWidget {
  const XploraBottomNavigationBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BottomNavigationBarState();
}

class _BottomNavigationBarState
    extends ConsumerState<XploraBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomNavigationBarProvider);

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == NavigationItem.home
                ? Colors.grey
                : Colors.black,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: currentIndex == NavigationItem.search
                ? Colors.grey
                : Colors.black,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark,
              color: currentIndex == NavigationItem.bookmarks
                  ? Colors.black
                  : Colors.grey),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: currentIndex == NavigationItem.notifications
                ? Colors.grey
                : Colors.black,
          ),
          label: '',
        ),
      ],
      currentIndex: currentIndex.index,
      onTap: (index) {
        ref.read(bottomNavigationBarProvider.notifier).state =
            NavigationItem.values[index];
      },
    );
  }
}
