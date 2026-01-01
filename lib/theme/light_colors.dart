import 'package:flutter/material.dart';

// ============================================================================
// LIGHT MODE COLOR SYSTEM
// ============================================================================

// SURFACE COLORS
Color bgPrimaryLight = const Color(0xffF0EFEB); /// Primary background
Color bgSecondaryLight = const Color(0xffEDEDED); /// Secondary background, cards
Color bgTertiaryLight = const Color(0xffDADADA); /// Tertiary background
Color borderLight = const Color(0xffC8C8C8); /// Borders and dividers
Color elevatedLight = const Color(0xffE4E4E4); /// Elevated surfaces

// TEXT COLORS
Color textPrimaryLight = const Color(0xff2F2F2F); /// Primary text
Color textSecondaryLight = const Color(0xff494949); /// Secondary text
Color textTertiaryLight = const Color(0xff828282); /// Tertiary text
Color textDisabledLight = const Color(0xffA1A1A1); /// Disabled text

// ============================================================================
// UTILITY & EFFECTS (LIGHT MODE)
// ============================================================================

// Border colors
Color cardContainerBorderLight = borderLight; /// Consistent border color for cards and containers

// Gradient
Gradient baseBackgroundLight = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xffFAFAF8),
    bgPrimaryLight,
  ],
); /// Page backgrounds, global layers
