import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/auth_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../dialogs/bottom_login_card.dart';

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
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: currentIndex == NavigationItem.xpc
                    ? Colors.grey
                    : Colors.black,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'XPC',
                style: TextStyle(
                  fontSize: 10,
                  color: currentIndex == NavigationItem.xpc
                      ? Colors.grey
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.store,
            color: currentIndex == NavigationItem.store
                ? Colors.grey
                : Colors.black,
          ),
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
      onTap: (index) async {
        if (NavigationItem.values[index] == NavigationItem.notifications) {
          // Show authentication sheet if user is not authenticated
          final authService = ref.read(authServiceProvider);
          if (!await authService.isSignedInFuture()) {
            if (context.mounted) {
              showBottomLoginCard(context);
            }
          } else {
            ref.read(bottomNavigationBarProvider.notifier).state =
                NavigationItem.values[index];
          }
        } else {
          ref.read(bottomNavigationBarProvider.notifier).state =
              NavigationItem.values[index];
        }
      },
    );
  }
}
