import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable settings switch tile widget.
///
/// Pass [onChanged] as `null` to render the tile in a disabled state.
/// Both the [Switch] and the tap ripple disable themselves natively when
/// [onChanged] is `null`, matching Flutter's own interactive-widget convention.
/// Disabled styling uses semantic design system tokens instead of opacity.
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  bool get _disabled => onChanged == null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: spacing8),
      decoration: BoxDecoration(
        color: _disabled
            ? context.colors.bgSecondary.withValues(alpha: 0.8)
            : context.colors.bgSecondary,
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
          onTap: _disabled ? null : () => onChanged!(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing24,
              vertical: spacing16,
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
                          color: _disabled
                              ? context.colors.textDisabled
                              : context.colors.textPrimary,
                          fontWeight: subtitle.isEmpty
                              ? FontWeight.normal
                              : FontWeight.w600,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: spacing4),
                        Text(
                          subtitle,
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
                const SizedBox(width: spacing12),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: value && !_disabled ? [switchActiveGlow] : null,
                    borderRadius: BorderRadius.circular(radiusLarge),
                  ),
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeTrackColor: _disabled ? brandPrimary.withValues(alpha: 0.7) : brandPrimary,
                    inactiveTrackColor: context.isDarkMode
                        ? bgPrimaryLight.withValues(alpha: 0.20)
                        : bgPrimaryDark.withValues(alpha: 0.20),
                    thumbColor: WidgetStateProperty.all(_disabled ? bgTertiaryLight : bgPrimaryLight),
                    trackOutlineColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.transparent;
                      }
                      return context.isDarkMode
                          ? _disabled ? bgTertiaryDark.withValues(alpha: 0.5) : bgPrimaryLight.withValues(alpha: 0.30)
                          : _disabled ? bgTertiaryLight : bgPrimaryDark.withValues(alpha: 0.30);
                    }),
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
