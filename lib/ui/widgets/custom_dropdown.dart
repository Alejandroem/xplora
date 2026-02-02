import 'package:flutter/material.dart';

import '../../theme.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.icon,
    this.isOptional = false,
    this.showLabel = true,
    this.width,
  });

  final String label;
  final String value;
  final List<String> items;
  final Function(String) onChanged;
  final IconData? icon;
  final bool isOptional;
  final bool showLabel;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: bodySmallStyle.copyWith(
              color: context.colors.textPrimary,
            ),
          ),
          const SizedBox(height: spacing8),
        ],
        Container(
          width: width,
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(radiusMedium),
            border: Border.all(
              color: context.colors.border,
              width: borderWidthDefault,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: context.colors.bgTertiary,
              focusColor: brandPrimary,
              hoverColor: brandPrimary.withValues(alpha: 0.05),
              highlightColor: brandPrimary.withValues(alpha: 0.1),
              splashColor: brandPrimary.withValues(alpha: 0.05),
              dividerColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacing16,
                  // vertical: spacing4,
                ),
                value: value.isEmpty ? null : value,
                hint: Text(
                  'Select $label',
                  style: captionStyle.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: context.colors.textSecondary,
                ),
                isExpanded: true,
                dropdownColor: context.colors.bgTertiary,
                style: bodyTextStyle.copyWith(
                  color: context.colors.textPrimary,
                ),
                selectedItemBuilder: (BuildContext context) {
                  return items.map<Widget>((String item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: context.colors.textSecondary,
                              size: iconSizeMedium,
                            ),
                            const SizedBox(width: spacing12),
                          ],
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                },
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: spacing16,
                        vertical: spacing8,
                      ),
                      child: Row(
                        children: [
                          if (icon != null) ...[
                            Icon(
                              icon,
                              color: context.colors.textSecondary,
                              size: iconSizeMedium,
                            ),
                            const SizedBox(width: spacing12),
                          ],
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle.copyWith(
                                color: context.colors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
