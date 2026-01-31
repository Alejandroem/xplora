import 'package:flutter/material.dart';
import '../../theme.dart';

/// Secondary button following the design system
/// - Transparent background with border
/// - Uses design system spacing, colors, radius, and elevation
/// - Implements proper button states (default, hover, disabled)
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon; /// Optional icon (displayed before text)
  final int? maxLines; /// Optional max lines for text overflow
  final double? borderRadius; /// Optional custom border radius

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.maxLines,
    this.borderRadius,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;

    // Border color remains same for all states
    final Color borderColor = context.colors.border;

    // Determine text color based on state
    final Color textColor;
    if (isDisabled) {
      textColor = context.isDarkMode
          ? textDisabledDark
          : textDisabledLight;
    } else {
      textColor = context.colors.textPrimary;
    }

    // Determine background color based on state
    final Color backgroundColor;
    if (isDisabled) {
      backgroundColor = context.colors.bgTertiary;
    } else if (_isHovered) {
      backgroundColor = const Color(0xFF414141);
    } else {
      backgroundColor = context.colors.bgSecondary;
    }

    // Determine shadow based on state
    final List<BoxShadow> shadows;
    if (_isHovered && !isDisabled) {
      shadows = [elevation1];
    } else {
      // Default, pressed, and disabled states use same shadow
      shadows = [
        const BoxShadow(
          color: Color(0x40000000), // Black with 25% opacity
          offset: Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];
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
            border: Border.all(
              color: borderColor,
              width: borderWidthDefault,
            ),
            boxShadow: shadows,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing16,
                  vertical: spacing12,
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
    );
  }
}
