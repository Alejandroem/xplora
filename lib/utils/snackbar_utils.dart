import 'package:flutter/material.dart';

import '../theme.dart';

/// Shows a reusable snackbar with error or success styling
void showXploraSnackBar(
  BuildContext context,
  String message, {
  bool isInfo = false,
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  // Determine background color
  final bgColor = isError
      ? errorColor
      : isInfo
          ? brandSecondary
          : successColor;

  // Use dark text color for success (bright green) and info (teal)
  // Use white text for error (dark red)
  final textColor = isError ? whiteClr : blackClr;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: bodySmallStyle.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: bgColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      margin: const EdgeInsets.all(spacing16),
    ),
  );
}
