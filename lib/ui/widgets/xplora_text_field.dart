import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable themed text field with consistent styling across the app
/// Features: purple focus border, glass background, proper text colors
class XploraTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  final TextStyle? style;
  final EdgeInsetsGeometry? contentPadding;

  const XploraTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
    this.style,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      enabled: enabled,
      style: style ?? bodyTextStyle.copyWith(color: textPrimary),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: bodyTextStyle.copyWith(color: textSecondary),
        hintStyle: bodyTextStyle.copyWith(color: textSecondary.withOpacity(0.6)),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: strokeDivider.withOpacity(0.3), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentPrimary, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentPrimary.withOpacity(0.2), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: feedbackAlert, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: feedbackAlert, width: 1),
        ),
        filled: true,
        fillColor: midSurface,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
