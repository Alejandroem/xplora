import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../theme/typography.dart';

/// Reusable primary button with green/purple background and glow effect
/// Hover state increases glow intensity
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool usePurple; /// If true, uses purple; if false, uses green (default)
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final int? maxLines;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.usePurple = false,
    this.fontSize,
    this.padding,
    this.height,
    this.width,
    this.maxLines
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.usePurple ? accentPrimary : accentSecondary;
    final textColor = widget.usePurple ? textPrimary : const Color(0xff121212);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: widget.padding ?? const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: widget.onPressed == null ? textSecondary : buttonColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: buttonColor.withOpacity(_isHovered ? 0.6 : 0.3),
                  blurRadius: _isHovered ? 12 : 6,
                  spreadRadius: _isHovered ? 2 : 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.text,
                style: bodyTextStyle.copyWith(
                  fontSize: widget.fontSize ?? 14,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
                maxLines: widget.maxLines,
                overflow: widget.maxLines!=null ? TextOverflow.ellipsis : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
