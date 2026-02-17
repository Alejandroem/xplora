import 'package:flutter/material.dart';
import '../../theme.dart';

/// Primary button following the design system
/// - Uses brand colors (primary/secondary)
/// - Implements proper button states (default, hover, disabled)
/// - Uses design system spacing, radius, and elevation
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final int? maxLines; /// Optional max lines for text overflow
  final Color? backgroundColor; /// Optional custom background color
  final Color? textColor; /// Optional custom text color
  final double? borderRadius; /// Optional custom border radius
  final double? height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.maxLines,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.height,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    // Background color - uses custom color if provided, otherwise brandPrimary for enabled, bgTertiary for disabled
    final Color backgroundColor;
    if (isDisabled) {
      backgroundColor = context.colors.bgTertiary;
    } else {
      backgroundColor = widget.backgroundColor ?? brandPrimary;
    }

    // Determine text color based on state
    final Color textColor;
    if (isDisabled) {
      textColor = widget.textColor ?? context.colors.textDisabled;
    } else {
      textColor = widget.textColor ?? bgPrimaryLight;
    }

    // Determine shadow based on state
    final List<BoxShadow> shadows;
    if (isDisabled) {
      shadows = [elevationNone]; // Disabled state uses elevation0
    } else if (_isPressed) {
      shadows = [elevationNone]; // Pressed state uses elevation0
    } else if (_isHovered) {
      shadows = [elevation2]; // Hover state uses elevation2
    } else {
      shadows = [elevation1]; // Default state uses elevation1
    }

    return SizedBox(
      height: widget.height,
      child: MouseRegion(
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
          onTapDown: (_) {
            if (!isDisabled) {
              setState(() => _isPressed = true);
            }
          },
          onTapUp: (_) {
            if (!isDisabled) {
              setState(() => _isPressed = false);
            }
          },
          onTapCancel: () {
            if (!isDisabled) {
              setState(() => _isPressed = false);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? radiusMedium),
              boxShadow: shadows,
              border: isDisabled ? Border.all(color: context.colors.border) : null,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: spacing16,
                    vertical: spacing12,
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
                if (_isHovered && !_isPressed)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x12FFFFFF), // White with 7% opacity
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? radiusMedium),
                      ),
                    ),
                  ),
                if (_isPressed)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x17000000), // Black with 9% opacity
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? radiusMedium),
                      ),
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
