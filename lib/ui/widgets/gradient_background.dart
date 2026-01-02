import 'package:flutter/material.dart';
import '../../theme.dart';

/// Reusable widget that applies the baseBackground gradient to any screen
/// Wrap your screen content with this widget to get the dark gradient background
class GradientBackground extends StatelessWidget {
  final Widget child;
  final double? height;

  const GradientBackground({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height ?? MediaQuery.of(context).size.height,
      child: Container(
        decoration: BoxDecoration(gradient: context.colors.baseBackground),
        child: child,
      ),
    );
  }
}
