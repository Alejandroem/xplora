import 'package:flutter/material.dart';
import 'dark_colors.dart';
import 'light_colors.dart';

/// Theme extension that provides context-aware colors
/// Automatically returns light or dark colors based on current theme
class AppColors extends ThemeExtension<AppColors> {
  // Text colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;

  // Background colors
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;

  // Border and utility colors
  final Color border;
  final Color elevated;
  final Color cardContainerBorder;

  // Gradients
  final Gradient baseBackground;

  // Icon color (maps to textPrimary per iconography rules)
  Color get iconColor => textPrimary;

  AppColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.border,
    required this.elevated,
    required this.cardContainerBorder,
    required this.baseBackground,
  });

  /// Light theme colors
  factory AppColors.light() {
    return AppColors(
      textPrimary: textPrimaryLight,
      textSecondary: textSecondaryLight,
      textTertiary: textTertiaryLight,
      textDisabled: textDisabledLight,
      bgPrimary: bgPrimaryLight,
      bgSecondary: bgSecondaryLight,
      bgTertiary: bgTertiaryLight,
      border: borderLight,
      elevated: elevatedLight,
      cardContainerBorder: cardContainerBorderLight,
      baseBackground: baseBackgroundLight,
    );
  }

  /// Dark theme colors
  factory AppColors.dark() {
    return AppColors(
      textPrimary: textPrimaryDark,
      textSecondary: textSecondaryDark,
      textTertiary: textTertiaryDark,
      textDisabled: textDisabledDark,
      bgPrimary: bgPrimaryDark,
      bgSecondary: bgSecondaryDark,
      bgTertiary: bgTertiaryDark,
      border: borderDark,
      elevated: elevatedDark,
      cardContainerBorder: cardContainerBorderDark,
      baseBackground: baseBackgroundDark,
    );
  }

  @override
  AppColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? border,
    Color? elevated,
    Color? cardContainerBorder,
    Gradient? baseBackground,
  }) {
    return AppColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      border: border ?? this.border,
      elevated: elevated ?? this.elevated,
      cardContainerBorder: cardContainerBorder ?? this.cardContainerBorder,
      baseBackground: baseBackground ?? this.baseBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      border: Color.lerp(border, other.border, t)!,
      elevated: Color.lerp(elevated, other.elevated, t)!,
      cardContainerBorder: Color.lerp(cardContainerBorder, other.cardContainerBorder, t)!,
      baseBackground: Gradient.lerp(baseBackground, other.baseBackground, t)!,
    );
  }
}
