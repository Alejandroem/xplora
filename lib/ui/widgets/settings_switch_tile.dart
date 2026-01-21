import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable settings switch tile widget
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: spacing8),
      decoration: BoxDecoration(
        color: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusLarge),
        border: Border.all(
          color: context.colors.border,
          width: borderWidthDefault,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: context.colors.textPrimary.withValues(alpha: 0.06),
          highlightColor: context.colors.textPrimary.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(radiusLarge),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: subtitle.isNotEmpty ? spacing16 : spacing24,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: bodyTextStyle.copyWith(
                          color: context.colors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: spacing4),
                        Text(
                          subtitle,
                          style: bodySmallStyle.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: spacing12),
                Switch.adaptive(
                  value: value,
                  onChanged: onChanged,
                  activeColor: brandPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
