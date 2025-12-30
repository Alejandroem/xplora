import 'package:flutter/material.dart';
import '../../theme.dart';

class ReusableBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final bool isLoading;
  final String? primaryButtonText;
  final VoidCallback? onPrimaryButtonPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryButtonPressed;
  final bool showPrimaryButton;
  final bool showSecondaryButton;

  const ReusableBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.isLoading = false,
    this.primaryButtonText,
    this.onPrimaryButtonPressed,
    this.secondaryButtonText,
    this.onSecondaryButtonPressed,
    this.showPrimaryButton = true,
    this.showSecondaryButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff121212), // Solid background to prevent text interference
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: brandPrimary.withOpacity(0.3),
            width: 2,
          ),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            title,
            style: h3Style.copyWith(color: textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          
          // Content
          content,
          
          const SizedBox(height: 24.0),
          
          // Buttons
          if (showPrimaryButton || showSecondaryButton) ...[
            if (showPrimaryButton && showSecondaryButton)
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: secondaryButtonText ?? 'Cancel',
                      onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: brandPrimary,
                            ),
                          )
                        : PrimaryButton(
                            text: primaryButtonText ?? 'Confirm',
                            onPressed: onPrimaryButtonPressed,
                          ),
                  ),
                ],
              )
            else if (showPrimaryButton)
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: brandPrimary,
                      ),
                    )
                  : PrimaryButton(
                      text: primaryButtonText ?? 'Confirm',
                      onPressed: onPrimaryButtonPressed,
                    )
            else if (showSecondaryButton)
              SecondaryButton(
                text: secondaryButtonText ?? 'Cancel',
                onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(),
              ),
          ],
        ],
      ),
    );
  }
}

void showReusableBottomSheet({
  required BuildContext context,
  required String title,
  required Widget content,
  bool isLoading = false,
  String? primaryButtonText,
  VoidCallback? onPrimaryButtonPressed,
  String? secondaryButtonText,
  VoidCallback? onSecondaryButtonPressed,
  bool showPrimaryButton = true,
  bool showSecondaryButton = false,
  bool isScrollControlled = true,
  bool enableDrag = true,
  bool isDismissible = true,
}) {
  showModalBottomSheet(
    isScrollControlled: isScrollControlled,
    enableDrag: enableDrag,
    isDismissible: isDismissible,
    context: context,
    backgroundColor: Colors.transparent, // Transparent to show custom background
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ReusableBottomSheet(
          title: title,
          content: content,
          isLoading: isLoading,
          primaryButtonText: primaryButtonText,
          onPrimaryButtonPressed: onPrimaryButtonPressed,
          secondaryButtonText: secondaryButtonText,
          onSecondaryButtonPressed: onSecondaryButtonPressed,
          showPrimaryButton: showPrimaryButton,
          showSecondaryButton: showSecondaryButton,
        ),
      );
    },
  );
}
