import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../application/providers/auth_service_providers.dart';
import '../../application/providers/navigation_providers.dart';
import '../../theme.dart';
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

    return GlassBottomNavBar(
      items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(
          LucideIcons.home,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          LucideIcons.search,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          LucideIcons.coins,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          LucideIcons.store,
        ),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(
          LucideIcons.bell,
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
            // showBottomLoginCard(context);
            Navigator.of(context).pushNamed('/signin');
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
