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
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: '',
        ),
      ],
      currentIndex: ref.watch(bottomNavigationBarProvider),
      onTap: (index) {
        ref.read(bottomNavigationBarProvider.notifier).state = index;
      },
    );
  }
}
