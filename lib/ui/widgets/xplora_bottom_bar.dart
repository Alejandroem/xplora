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

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: currentIndex == NavigationItem.home
                ? Colors.black
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: currentIndex == NavigationItem.search
                ? Colors.black
                : Colors.grey,
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
                    ? Colors.black
                    : Colors.grey,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'XPC',
                style: TextStyle(
                  fontSize: 10,
                  color: currentIndex == NavigationItem.xpc
                      ? Colors.black
                      : Colors.grey,
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
                ? Colors.black
                : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.notifications,
            color: currentIndex == NavigationItem.notifications
                ? Colors.black
                : Colors.grey,
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
      ),
    );
  }
}
