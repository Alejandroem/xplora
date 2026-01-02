import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

// ============================================================================
// TYPOGRAPHY RULES:
// • Colors are set by the theme, not hardcoded here
// • Use .copyWith(color: ...) when applying these styles in the theme
// • Heading hierarchy: h1 (28px) > h2 (22px) > h3 (18px)
// • Body text: regular (16px) > small (14px)
// • Caption and button text: 12px (fontSize set to 15 currently)
// ============================================================================

// ============================================================================
// HEADING STYLES (Questrial font)
// ============================================================================

/// Heading/Large - Screen Titles
/// Questrial, 400, 28px, line height 36px
/// Color should be set by theme (typically textPrimary)
final h1Style = GoogleFonts.questrial(
  fontSize: 28,
  fontWeight: FontWeight.w400,
  height: 36 / 28,
);

/// Heading/Medium - Section Titles
/// Questrial, 400, 22px, line height 30px
/// Color should be set by theme (typically textPrimary)
final h2Style = GoogleFonts.questrial(
  fontSize: 22,
  fontWeight: FontWeight.w400,
  height: 30 / 22,
);

/// Heading/Small - Subsections
/// Questrial, 400, 18px, line height 26px
/// Color should be set by theme (typically textSecondary)
final h3Style = GoogleFonts.questrial(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 26 / 18,
);

// ============================================================================
// BODY TEXT STYLES (Inter font)
// ============================================================================

/// Body/Regular - Main content
/// Inter, 400, 16px, line height 24px
/// Color should be set by theme (typically textPrimary)
final bodyTextStyle = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 24 / 16,
);

/// Body/Small - Description & metadata
/// Inter, 400, 14px, line height 20px
/// Color should be set by theme (typically textSecondary)
final bodySmallStyle = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 20 / 14,
);

// ============================================================================
// SUPPORTING TEXT STYLES (Inter font)
// ============================================================================

/// Caption - Hints & helper text
/// Inter, 400, 12px, line height 16px
/// Color should be set by theme (typically textTertiary)
final captionStyle = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
);

/// Button Text
/// Inter, 400, 12px, line height 16px
/// Color should be set by theme (typically textPrimary or white)
final buttonTextStyle = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
);

// ============================================================================
// SPECIAL STYLES
// ============================================================================

/// XP/Numeric - XP values (e.g., "+50 XP")
/// Questrial, 400, line height 28px
/// Color use xpColor
final xpNumberStyle = GoogleFonts.questrial(
  fontWeight: FontWeight.w400,
  height: 28 / 20,
  color: xpColor,
);