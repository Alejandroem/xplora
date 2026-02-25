import 'package:flutter/material.dart';

/// Interest model - supports both IconData and SVG path
class Interest {
  final String id;
  final String label;
  final IconData? icon;
  final String? svgPath;

  const Interest({
    required this.id,
    required this.label,
    this.icon,
    this.svgPath,
  }) : assert(icon != null || svgPath != null,
            'Either icon or svgPath must be provided');
}
