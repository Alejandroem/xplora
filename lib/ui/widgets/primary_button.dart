import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable primary button with green/purple background and glow effect
/// Hover state increases glow intensity
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool useSecondary; /// If true, uses secondary; if false, uses primary
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final int? maxLines;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.useSecondary = false,
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
    final buttonColor = widget.useSecondary ? brandSecondary : brandPrimary;
    final textColor = widget.useSecondary ? context.colors.textPrimary : null;

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
              color: widget.onPressed == null ? context.colors.bgSecondary : buttonColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.onPressed==null ? [] : [
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
                style: buttonTextStyle.copyWith(
                  fontSize: widget.fontSize,
                  color: textColor
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
