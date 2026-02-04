import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable base dialog with consistent styling
class BaseDialog extends StatelessWidget {
  final Widget icon;
  final String title;
  final String description;
  final Widget? warningWidget;
  final Widget? content;
  final List<Widget> actions;
  final bool showCloseButton;
  final bool dismissOnBarrierTap;

  const BaseDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.warningWidget,
    this.content,
    required this.actions,
    this.showCloseButton = false,
    this.dismissOnBarrierTap = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dismissOnBarrierTap ? () => Navigator.of(context).pop() : null,
      child: Material(
        color: Colors.black54, // Standard Flutter dialog barrier color
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping on dialog
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(spacing16),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    decoration: BoxDecoration(
                      color: context.colors.bgPrimary,
                      borderRadius: BorderRadius.circular(radiusLarge),
                      border: Border.all(
                        color: context.colors.border.withValues(alpha: 0.38),
                        width: borderWidthDefault,
                      ),
                    ),
                    padding: const EdgeInsets.all(spacing24),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Icon
                          icon,
                          const SizedBox(height: spacing24),

                          // Title
                          Text(
                            title,
                            style: h2Style.copyWith(
                              color: context.colors.textPrimary,
                              fontSize: 24
                            ),
                            textAlign: TextAlign.center,
                          ),

                          // Description
                          if (description.isNotEmpty) ...[
                            const SizedBox(height: spacing16),
                            Text(
                              description,
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          // Optional warning widget
                          if (warningWidget != null) ...[
                            const SizedBox(height: spacing16),
                            warningWidget!,
                          ],

                          // Optional custom content
                          if (content != null) ...[
                            const SizedBox(height: spacing24),
                            content!,
                          ],

                          const SizedBox(height: spacing32),

                          // Actions
                          ...actions,
                        ],
                      ),
                    ),
                  ),
                ),
                // Close button positioned in top-right
                if (showCloseButton)
                  Positioned(
                    top: spacing48,
                    right: spacing48,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(spacing8),
                        decoration: BoxDecoration(
                          color: context.colors.elevated.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                context.colors.elevated.withValues(alpha: 0.5),
                            width: borderWidthDefault,
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          color: context.colors.iconColor,
                          size: iconSizeSmall,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
