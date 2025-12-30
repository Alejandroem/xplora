import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// Shows a reusable snackbar with error or success styling
void showXploraSnackBar(
  BuildContext context,
  String message, {
  bool isInfo = false,
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: isError ? errorColor : isInfo ? Colors.blue : successColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(16),
    ),
  );
}
