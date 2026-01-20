import 'package:flutter/material.dart';
import '../../theme.dart';

/// Secondary button following the design system
/// - Transparent background with border
/// - Uses design system spacing, colors, radius, and elevation
/// - Implements proper button states (default, hover, disabled)
/// - No customization parameters to ensure consistency
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon; /// Optional icon (displayed before text)
  final int? maxLines; /// Optional max lines for text overflow

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.maxLines
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    // Determine border color based on state
    final Color borderColor;
    if (isDisabled) {
      borderColor = context.isDarkMode
          ? buttonDisabledDark
          : buttonDisabledLight;
    } else {
      borderColor = context.colors.border;
    }

    // Determine text color based on state
    final Color textColor;
    if (isDisabled) {
      textColor = context.isDarkMode
          ? textDisabledDark
          : textDisabledLight;
    } else {
      textColor = context.colors.textPrimary;
    }

    // Determine shadow based on state
    final List<BoxShadow> shadows;
    if (isDisabled) {
      shadows = []; // No shadow for disabled state
    } else if (_isHovered) {
      shadows = [buttonHoverShadow];
    } else {
      shadows = []; // No shadow in default state for secondary button
    }

    return MouseRegion(
      onEnter: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = true);
        }
      },
      onExit: (_) {
        if (!isDisabled) {
          setState(() => _isHovered = false);
        }
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: spacing16,
            vertical: spacing12,
          ),
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: borderColor,
              width: borderWidthDefault,
            ),
            boxShadow: shadows,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SizedBox(width: spacing8),
                ],
                Flexible(
                  child: Text(
                    widget.text,
                    style: buttonTextStyle.copyWith(
                      color: textColor,
                    ),
                    maxLines: widget.maxLines,
                    overflow: widget.maxLines!=null ? TextOverflow.ellipsis : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
