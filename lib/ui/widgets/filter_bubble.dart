import 'package:flutter/material.dart';
import '../../theme.dart';

/// Filter bubble widget following the design system
/// - Pill-shaped with radiusPill for fully circular ends
/// - Uses design system spacing, colors, and elevation
/// - Implements proper selected/unselected states
/// - No customization parameters to ensure consistency
class FilterBubble extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;
  final bool iconAtEnd;

  const FilterBubble({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.iconAtEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? brandPrimary : null,
          borderRadius: BorderRadius.circular(radiusPill),
          border: Border.all(
            color: isSelected
                ? brandPrimary
                : context.colors.border,
            width: borderWidthDefault,
          ),
          boxShadow: isSelected
              ? [elevation1]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !iconAtEnd) ...[
              icon!,
              const SizedBox(width: spacing4),
            ],
            Text(
              text,
              style: bodySmallStyle.copyWith(
                color: isSelected ? whiteClr : context.colors.textPrimary,
              ),
            ),
            if (icon != null && iconAtEnd) ...[
              const SizedBox(width: spacing4),
              icon!,
            ],
          ],
        ),
      ),
    );
  }
}
