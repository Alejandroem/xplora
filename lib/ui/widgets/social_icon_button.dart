import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class SocialIconButton extends StatelessWidget {
  SocialIconButton({super.key, this.icon, this.iconPath, this.onPressed});

  IconData? icon;
  String? iconPath;
  dynamic onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: accentPrimary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: iconPath != null
            ? Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            iconPath!,
            width: 40,
            height: 40,
          ),
        )
            : Icon(
          icon!,
          color: textPrimary,
          size: 32,
        ),
      ),
    );
  }
}
