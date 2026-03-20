import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme.dart';

/// Reusable settings tile widget for navigation items
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final String? leadingIcon;
  final Widget? trailing;
  final bool showTrailing;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.leadingIcon,
    this.trailing,
    this.showTrailing = true,
  });

  bool get _disabled => onTap == null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacing8),
      child: Material(
        color: _disabled
            ? context.colors.bgSecondary.withValues(alpha: 0.7)
            : context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(radiusLarge),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radiusLarge),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(radiusLarge),
            splashColor: context.colors.textPrimary.withValues(alpha: 0.06),
            highlightColor: context.colors.textPrimary.withValues(alpha: 0.03),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing24,
                vertical: subtitle != null ? spacing16 : spacing24,
              ),
              child: Row(
                children: [
                  if (leadingIcon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(spacing16),
                      decoration: BoxDecoration(
                        color: brandSecondary.withAlpha(35),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(radiusMedium),
                        ),
                      ),
                      child: SvgPicture.asset(
                        leadingIcon!,
                        width: iconSizeLarge,
                        height: iconSizeLarge,
                      ),
                    ),
                    const SizedBox(width: spacing16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: bodyTextStyle.copyWith(
                            color: _disabled
                                ? context.colors.textDisabled
                                : context.colors.textPrimary,
                            fontWeight: subtitle == null
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: spacing4),
                          Text(
                            subtitle!,
                            style: bodySmallStyle.copyWith(
                              color: _disabled
                                  ? context.colors.textDisabled
                                  : context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showTrailing) ...[
                    const SizedBox(width: spacing12),
                    trailing ??
                        Icon(
                          Icons.chevron_right_rounded,
                          color: _disabled
                              ? context.colors.textDisabled
                              : context.colors.textPrimary,
                          size: iconSizeLarge,
                        ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
