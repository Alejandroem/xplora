import 'package:flutter/material.dart';
import 'app_colors_extension.dart';

/// Convenient extension to access theme colors from BuildContext
extension ThemeContext on BuildContext {
  /// Get theme-aware colors
  /// Returns AppColors.light() or AppColors.dark() based on current theme
  AppColors get colors => Theme.of(this).extension<AppColors>()!;

  /// Check if dark mode is active
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
