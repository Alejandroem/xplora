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
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? brandPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius ?? 20),
          border: Border.all(
            color: isSelected
                ? brandPrimary
                : context.colors.border,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: brandPrimary.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: iconAtEnd ? [
            Text(
              text,
              style: bodyTextStyle.copyWith(
                fontSize: fontSize ?? 13,
                fontWeight: isSelected 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                color: isSelected ? context.colors.textPrimary : context.colors.textPrimary,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              icon!,
            ],
          ] : [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 6),
            ],
            Text(
              text,
              style: bodyTextStyle.copyWith(
                fontSize: fontSize ?? 13,
                fontWeight: isSelected 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                color: isSelected ? context.colors.textPrimary : context.colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
