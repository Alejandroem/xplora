import 'package:flutter/material.dart';
import '../../theme.dart';

/// Primary button following the design system
/// - Uses brand colors (primary/secondary)
/// - Implements proper button states (default, hover, disabled)
/// - Uses design system spacing, radius, and elevation
/// - No customization parameters to ensure consistency
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool useSecondary; /// If true, uses secondary; if false, uses primary
  final int? maxLines; /// Optional max lines for text overflow

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.useSecondary = false,
    this.maxLines,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;
    final buttonColor = widget.useSecondary ? brandSecondary : brandPrimary;

    // Determine button background color based on state
    final Color backgroundColor;
    if (isDisabled) {
      backgroundColor = context.isDarkMode
          ? buttonDisabledDark
          : buttonDisabledLight;
    } else {
      backgroundColor = buttonColor;
    }

    // Determine text color based on state and button type
    final Color textColor;
    if (isDisabled) {
      textColor = context.isDarkMode
          ? textDisabledDark
          : textDisabledLight;
    } else if (widget.useSecondary) {
      // Secondary button has dark text on teal background
      textColor = context.colors.textPrimary;
    } else {
      // Primary button has white text on purple background
      textColor = whiteClr;
    }

    // Determine shadow based on state
    final List<BoxShadow> shadows;
    if (isDisabled) {
      shadows = []; // No shadow for disabled state
    } else if (_isHovered) {
      shadows = [buttonHoverShadow];
    } else {
      shadows = [buttonDefaultShadow];
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
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radiusMedium),
            boxShadow: shadows,
          ),
          child: Center(
            child: Text(
              widget.text,
              style: buttonTextStyle.copyWith(
                color: textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: widget.maxLines,
              overflow: widget.maxLines != null ? TextOverflow.ellipsis : null,
            ),
          ),
        ),
      ),
    );
  }
}
