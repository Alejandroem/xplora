import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/typography.dart';

class CustomDropdown extends StatelessWidget {
  CustomDropdown({super.key, required this.label, required this.value, required this.items, required this.onChanged, required this.icon, this.isOptional = false});

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
        Text(
          label,
          style: h3Style.copyWith(
            color: textPrimary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: cardContainerBorder,
              width: 1,
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: bgTertiary,
              focusColor: brandPrimary.withOpacity(0.1),
              hoverColor: brandPrimary.withOpacity(0.05),
              highlightColor: brandPrimary.withOpacity(0.1),
              splashColor: brandPrimary.withOpacity(0.05),
              dividerColor: Colors.transparent,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                value: value.isEmpty ? null : value,
                hint: Text(
                  'Select $label',
                  style: bodyTextStyle.copyWith(
                    color: textSecondary,
                    fontSize: 16,
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: textSecondary,
                ),
                isExpanded: true,
                dropdownColor: bgTertiary,
                style: bodyTextStyle.copyWith(
                  fontSize: 16,
                ),
                selectedItemBuilder: (BuildContext context) {
                  return items.map<Widget>((String item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle.copyWith(
                                fontSize: 16,
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
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item,
                              style: bodyTextStyle.copyWith(
                                fontSize: 16,
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
