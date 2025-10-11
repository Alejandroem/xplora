import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Bottom navbar with transparent glass effect and thin purple divider on top
/// Light, floating feel with backdrop blur
class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: accentPrimary.withOpacity(0.3), /// Thin purple divider on top
            width: 1,
          ),
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12, /// Light blur for floating feel
            sigmaY: 12,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
            backgroundColor: const Color.fromRGBO(18, 18, 18, 0.4), /// More transparent for light feel
            selectedItemColor: accentPrimary, /// Lime green for active states
            unselectedItemColor: textSecondary, /// Gray for inactive icons
            type: BottomNavigationBarType.fixed, /// Keeps items fixed width
            elevation: 0, /// No shadow, using blur instead
            showSelectedLabels: false, /// No labels, only icons
            showUnselectedLabels: false, /// No labels, only icons
          ),
        ),
      ),
    );
  }
}
