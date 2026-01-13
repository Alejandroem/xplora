import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable segmented tab widget that matches the design system.
///
/// Uses GlassContainer styling and provides a clean tab interface
/// similar to the Quest tabs but more generic and reusable.
class SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;

  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: radiusPill,
      padding: const EdgeInsets.all(spacing4),
      child: Row(
        children: List.generate(
          tabs.length,
          (index) => Expanded(
            child: _buildTabButton(
              context: context,
              label: tabs[index],
              index: index,
              isSelected: selectedIndex == index,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return TextButton(
      onPressed: () {
        if (!isSelected) {
          onTabSelected(index);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          vertical: spacing8,
          horizontal: spacing12,
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
        ),
        backgroundColor:
            isSelected ? context.colors.bgTertiary : Colors.transparent,
        foregroundColor: isSelected
            ? context.colors.textPrimary
            : context.colors.textSecondary,
      ),
      child: Center(
        child: Text(
          label,
          style: bodyTextStyle.copyWith(
            color: isSelected
                ? context.colors.textPrimary
                : context.colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
