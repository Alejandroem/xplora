import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import 'base_dialog.dart';

/// Reusable Confirmation Dialog
/// Shows a confirmation dialog with customizable icon, title, and description
Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String svgIconPath,
  required String title,
  required String description,
  double iconWidth = 36,
  double iconHeight = 36,
  Color? iconBackgroundColor,
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
  Color? confirmButtonColor,
}) {
  final effectiveIconBackgroundColor = iconBackgroundColor ?? warningColor;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    useSafeArea: false, // Allow dialog to cover status bar
    builder: (BuildContext context) {
      return BaseDialog(
        icon: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: effectiveIconBackgroundColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(radiusLarge),
            border: Border.all(
              color: effectiveIconBackgroundColor.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: SvgPicture.asset(
              svgIconPath,
              width: iconWidth,
              height: iconHeight,
            ),
          ),
        ),
        title: title,
        description: description,
        actions: [
          // Action Buttons Row
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: SecondaryButton(
                  text: cancelText,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: spacing16),

              // Confirm Button
              Expanded(
                child: PrimaryButton(
                  text: confirmText,
                  backgroundColor: confirmButtonColor ?? warningColor,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
