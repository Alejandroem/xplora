import 'package:flutter/material.dart';

class DistanceText extends StatelessWidget {
  final String number;
  final String suffix;
  final TextStyle style;

  const DistanceText({
    super.key,
    required this.number,
    required this.suffix,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            number,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(suffix, style: style),
      ],
    );
  }
}
