import 'package:flutter/material.dart';
import '../confirmation_dialog.dart';

/// Logout Confirmation Dialog
/// Shows a confirmation dialog with logout icon when user attempts to logout
Future<bool?> showLogoutDialog(BuildContext context) {
  return showConfirmationDialog(
    context,
    svgIconPath: 'assets/svg/logout.svg',
    title: 'Logout from this device',
    description: 'Are you sure you want to logout from this device?',
    iconWidth: 36,
    iconHeight: 36,
  );
}
