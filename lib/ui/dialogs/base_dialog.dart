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

  const BaseDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.warningWidget,
    this.content,
    required this.actions,
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(0.7), // Darker backdrop
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: GlassContainer(
                  borderRadius: 20,
                  padding: const EdgeInsets.all(32.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon
                        icon,
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          title,
                          style: h1Style,
                          textAlign: TextAlign.center,
                        ),

                        // Description
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            description,
                            style: bodyTextStyle.copyWith(
                              color: textSecondary,
                              fontSize: 16,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // Optional warning widget
                        if (warningWidget != null) ...[
                          const SizedBox(height: 18),
                          warningWidget!,
                        ],

                        // Optional custom content
                        if (content != null) ...[
                          const SizedBox(height: 24),
                          content!,
                        ],

                        const SizedBox(height: 32),

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
                  top: 46,
                  right: 46,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: elevated.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: elevated.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
