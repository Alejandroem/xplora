import 'package:flutter/material.dart';
import '../confirmation_dialog.dart';

/// Reset Account Access Confirmation Dialog
/// Shows a confirmation dialog with reset icon when user attempts to reset their account access
Future<bool?> showResetAccountAccessDialog(BuildContext context) {
  return showConfirmationDialog(
    context,
    svgIconPath: 'assets/svg/reset.svg',
    title: 'Reset Account Access',
    description: 'Are you sure you want to reset your account access?',
    iconWidth: 25,
    iconHeight: 25,
  );
}
