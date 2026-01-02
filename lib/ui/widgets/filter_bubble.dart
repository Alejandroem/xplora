import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable filter bubble widget with consistent styling
/// Used for category chips, filter options, and other selectable items
class FilterBubble extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? fontSize;
  final bool iconAtEnd;

  const FilterBubble({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.iconAtEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: spacing16,
          vertical: spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? brandPrimary : null,
          borderRadius: BorderRadius.circular(borderRadius ?? radiusLarge),
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
                fontSize: fontSize,
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
