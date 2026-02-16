import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

/// Delete Account Confirmation Dialog
/// Shows a confirmation dialog with trash icon when user attempts to delete their account
Future<bool?> showDeleteAccountConfirmationDialog(BuildContext context) {
  return showConfirmationDialog(
    context,
    svgIconPath: 'assets/svg/delete.svg',
    title: 'Delete Account',
    description: 'Are you sure you want to delete your account?',
    iconWidth: 31,
    iconHeight: 36,
  );
}
