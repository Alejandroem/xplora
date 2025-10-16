import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Reusable secondary button with transparent background and purple thin border
/// Used for secondary actions like "Clear Filters"
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final bool isEnabled;
  final double? width;
  final Widget? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.fontSize,
    this.padding,
    this.isEnabled = true,
    this.width,
    this.icon,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isEnabled ? widget.onPressed : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          padding: widget.padding ?? const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.transparent, /// Transparent background
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isEnabled 
                  ? accentPrimary.withOpacity(_isHovered ? 0.8 : 0.5) /// Purple border with hover effect
                  : accentPrimary.withOpacity(0.3), /// Dimmed when disabled
              width: 1, /// Thin border
            ),
            boxShadow: widget.isEnabled && _isHovered
                ? [
                    BoxShadow(
                      color: accentPrimary.withOpacity(0.2),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: bodyTextStyle.copyWith(
                    fontSize: widget.fontSize ?? 14,
                    fontWeight: FontWeight.bold,
                    color: widget.isEnabled 
                        ? textPrimary /// White text when enabled
                        : textSecondary, /// Gray text when disabled
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
