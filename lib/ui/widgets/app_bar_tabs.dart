import 'package:flutter/material.dart';
import '../../theme.dart';

class AppBarTabs extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const AppBarTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: spacing8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int index = 0; index < tabs.length; index++) ...[
            if (index > 0) const SizedBox(width: 48), // One finger gap
            GestureDetector(
              onTap: () => onTabSelected(index),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: spacing8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tabs[index],
                      style: bodyTextStyle.copyWith(
                        color: selectedIndex == index
                            ? context.colors.textPrimary
                            : context.colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: spacing8),
                    // Indicator only under text
                    Container(
                      height: 2,
                      width: 56, // Fixed width for indicator
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? brandPrimary
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
