import 'package:flutter/material.dart';

import '../../theme.dart';

/// Reusable settings tile widget for navigation items
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final IconData? leadingIcon;
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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: context.colors.iconColor,
              size: iconSizeMedium,
            )
          : null,
      title: Text(
        title,
        style: bodyTextStyle.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: bodySmallStyle.copyWith(
                color: context.colors.textSecondary,
              ),
            )
          : null,
      trailing: showTrailing
          ? (trailing ??
              Icon(
                Icons.arrow_forward_ios,
                color: context.colors.iconColor,
                size: iconSizeSmall,
              ))
          : null,
      onTap: onTap,
    );
  }
}
