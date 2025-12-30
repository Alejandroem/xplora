import 'package:flutter/material.dart';

// Legacy colors (to be phased out)
Color majjoreleBlue = const Color(0xff784Ef4);
Color springBud = const Color(0xffAFF500);
Color raisingBlack = const Color(0xff232632);
Color whiteSmoke = const Color(0xfff5F5F5);

// ============================================================================
// DARK MODE COLOR SYSTEM
// ============================================================================

// SURFACE COLORS
Color bgPrimary = const Color(0xff1A1A1A); /// Primary background
Color bgSecondary = const Color(0xff2D2C2F); /// Secondary background, cards
Color bgTertiary = const Color(0xff363538); /// Tertiary background
Color border = const Color(0xff4C4B4D); /// Borders and dividers
Color elevated = const Color(0xff5F5F5F); /// Elevated surfaces

// TEXT COLORS
Color textPrimary = const Color(0xffF5F5F5); /// Primary text
Color textSecondary = const Color(0xffEFEFEF); /// Secondary text
Color textTertiary = const Color(0xffDDDCDC); /// Tertiary text
Color textDisabled = const Color(0xffCBACAA); /// Disabled text

// BRAND COLORS
/// Identity, XP visuals, highlights, active states, progress accents
Color brandPrimary = const Color(0xffA855F7); /// Purple - Primary brand color
/// Exploration, discovery, secondary highlights, map/places/navigation accents
Color brandSecondary = const Color(0xff32E1F1); /// Teal - Secondary brand color

// SYSTEM COLORS
Color xpColor = const Color(0xff8B47FF); /// XP and progression
Color successColor = const Color(0xff97E959); /// Success states
Color warningColor = const Color(0xffFF5715); /// Warning states
Color errorColor = const Color(0xffE00808); /// Error states

// ============================================================================
// UTILITY & EFFECTS
// ============================================================================

// Border colors
Color cardContainerBorder = brandPrimary.withOpacity(0.1); /// Purple border at 10% opacity

// Gradient
Gradient baseBackground = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color(0xff000014),
    bgPrimary,
  ],
); /// Page backgrounds, global layers

// Blur values
int cardContainerBlur = 12; /// Depth and layering without boxes
int modalOverlayBlur = 18; /// Modal overlay blur

// Icons values
Color iconColor = Colors.white; /// Main icon color (White)

