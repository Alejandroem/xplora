import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme.dart';

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
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 76 + bottomPadding, /// Fixed navbar height + safe area
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.colors.border, /// Thin divider on top
            width: borderWidthDefault,
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
            backgroundColor: context.colors.bgPrimary,
            selectedItemColor: brandPrimary, /// Lime green for active states
            unselectedItemColor: context.colors.textPrimary.withValues(alpha: 0.5), /// Gray for inactive icons
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
