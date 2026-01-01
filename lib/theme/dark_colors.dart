import 'package:flutter/material.dart';

// ============================================================================
// DARK MODE COLOR SYSTEM
// ============================================================================

// SURFACE COLORS
Color bgPrimaryDark = const Color(0xff1A1A1A); /// Primary background
Color bgSecondaryDark = const Color(0xff2D2C2F); /// Secondary background, cards
Color bgTertiaryDark = const Color(0xff363538); /// Tertiary background
Color borderDark = const Color(0xff4C4B4D); /// Borders and dividers
Color elevatedDark = const Color(0xff5F5F5F); /// Elevated surfaces

// TEXT COLORS
Color textPrimaryDark = const Color(0xffF5F5F5); /// Primary text
Color textSecondaryDark = const Color(0xffEFEFEF); /// Secondary text
Color textTertiaryDark = const Color(0xffDDDCDC); /// Tertiary text
Color textDisabledDark = const Color(0xffCBACAA); /// Disabled text

// ============================================================================
// UTILITY & EFFECTS (DARK MODE)
// ============================================================================

// Border colors
Color cardContainerBorderDark = borderDark; /// Consistent border color for cards and containers

// Gradient
Gradient baseBackgroundDark = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xff000014),
    bgPrimaryDark,
  ],
); /// Page backgrounds, global layers

// Blur values
int cardContainerBlur = 12; /// Depth and layering without boxes
int modalOverlayBlur = 18; /// Modal overlay blur
