import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable themed text field with consistent styling across the app
/// Features: purple focus border, glass background, proper text colors, inline validation
class XploraTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool isEnabled;
  final int? maxLength;
  final FocusNode? focusNode;
  final void Function(PointerEvent)? onTapOutside;

  const XploraTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.isEnabled = true,
    this.maxLength,
    this.focusNode,
    this.onTapOutside,
  });

  @override
  State<XploraTextField> createState() => _XploraTextFieldState();
}

class _XploraTextFieldState extends State<XploraTextField> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = _errorText != null && _errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // External label
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: bodySmallStyle.copyWith(
              color: hasError ? errorColor : context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing8),
        ],

        // Text field
        TextFormField(
          focusNode: widget.focusNode,
          onTapOutside: widget.onTapOutside ?? (event) {
            FocusScope.of(context).unfocus();
          },
          controller: widget.controller,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          enabled: widget.isEnabled,
          validator: (value) {
            final error = widget.validator?.call(value);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _errorText = error;
                });
              }
            });
            return error;
          },
          style: bodyTextStyle,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: captionStyle,
            errorStyle: const TextStyle(height: 0, fontSize: 0), // Hide default error
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(color: context.colors.border, width: borderWidthDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(color: brandPrimary, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(color: context.colors.border, width: borderWidthDefault),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(color: errorColor, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
              borderSide: BorderSide(color: errorColor, width: 2),
            ),
            filled: true,
            fillColor: widget.isEnabled ? context.colors.bgSecondary : context.colors.bgTertiary,
            contentPadding: const EdgeInsets.symmetric(horizontal: spacing16, vertical: spacing12)
          ),
        ),

        // Custom error text aligned with text field start
        if (hasError) ...[
          const SizedBox(height: spacing4),
          Text(
            _errorText!,
            style: captionStyle.copyWith(color: errorColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
