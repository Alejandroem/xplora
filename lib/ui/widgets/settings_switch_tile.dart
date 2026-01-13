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
    return SwitchListTile(
      title: Text(
        title,
        style: bodyTextStyle.copyWith(
          color: context.colors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: bodySmallStyle.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: brandPrimary,
    );
  }
}
