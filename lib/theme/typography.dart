import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

// ============================================================================
// HEADING STYLES (Questrial font)
// ============================================================================

/// Heading/Large - Screen Titles
/// Questrial, 400, 28px, line height 36px
final h1Style = GoogleFonts.questrial(
  fontSize: 28,
  fontWeight: FontWeight.w400,
  height: 36 / 28,
  color: textPrimary,
);

/// Heading/Medium - Section Titles
/// Questrial, 400, 22px, line height 30px
final h2Style = GoogleFonts.questrial(
  fontSize: 22,
  fontWeight: FontWeight.w400,
  height: 30 / 22,
  color: textPrimary,
);

/// Heading/Small - Subsections
/// Questrial, 400, 18px, line height 26px
final h3Style = GoogleFonts.questrial(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  height: 26 / 18,
  color: textSecondary,
);

// ============================================================================
// BODY TEXT STYLES (Inter font)
// ============================================================================

/// Body/Regular - Main content
/// Inter, 400, 16px, line height 24px
final bodyTextStyle = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  height: 24 / 16,
  color: whiteClr,
);

/// Body/Small - Description & metadata
/// Inter, 400, 14px, line height 20px
final bodySmallStyle = GoogleFonts.inter(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 20 / 14,
  color: textSecondary,
);

// ============================================================================
// SUPPORTING TEXT STYLES (Inter font)
// ============================================================================

/// Caption - Hints & helper text
/// Inter, 400, 12px, line height 16px
final captionStyle = GoogleFonts.inter(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
  color: textTertiary,
);

/// Button Text
/// Inter, 400, 12px, line height 16px
final buttonTextStyle = GoogleFonts.inter(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  height: 16 / 12,
  color: whiteClr,
);

// ============================================================================
// SPECIAL STYLES
// ============================================================================

/// XP/Numeric - XP values (e.g., "+50 XP")
/// Questrial, 400, 20px, line height 28px
final xpNumberStyle = GoogleFonts.questrial(
  fontSize: 20,
  fontWeight: FontWeight.w400,
  height: 28 / 20,
  color: xpColor,
);
