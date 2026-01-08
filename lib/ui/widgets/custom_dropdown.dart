import 'package:flutter/material.dart';

import '../../theme.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown(
      {super.key,
      required this.label,
      required this.value,
      required this.items,
      required this.onChanged,
      required this.icon,
      this.isOptional = false});

  String label;
  String value;
  List<String> items;
  Function(String) onChanged;
  IconData icon;
  bool isOptional;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: bodySmallStyle),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.colors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.colors.cardContainerBorder,
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: context.colors.bgTertiary,
              focusColor: brandPrimary,
              hoverColor: brandPrimary.withOpacity(0.05),
              highlightColor: brandPrimary.withOpacity(0.1),
              splashColor: brandPrimary.withOpacity(0.05),
              dividerColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                value: value.isEmpty ? null : value,
                hint: Text('Select $label', style: captionStyle),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.colors.textSecondary,
                ),
                isExpanded: true,
                dropdownColor: context.colors.bgTertiary,
                style: bodyTextStyle,
                selectedItemBuilder: (BuildContext context) {
                  return items.map<Widget>((String item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: context.colors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle,
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
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: context.colors.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle,
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
