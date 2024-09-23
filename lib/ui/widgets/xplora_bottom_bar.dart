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
    final isIndexZero = currentIndex == 1;

    return BottomNavigationBar(
      backgroundColor: isIndexZero ? Colors.black : Colors.white,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: isIndexZero ? Colors.white : Colors.black,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: isIndexZero ? Colors.white : Colors.black,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: isIndexZero ? Colors.white : Colors.black,
          ),
          label: '',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        ref.read(bottomNavigationBarProvider.notifier).state = index;
      },
    );
  }
}
