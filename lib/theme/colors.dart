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
Color cardContainerBorder = border; /// Consistent border color for cards and containers

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

// Standard colors
Color whiteClr = Colors.white;

// ============================================================================
// BUTTON STATE SYSTEM
// ============================================================================
// STATE RULES:
// • Only one primary action per screen
// • Disabled elements do not receive elevation
// • Active = temporary, Selected = persistent
// • XP color is NOT used for buttons (use brand-primary)
// • Buttons → brand-primary (fill)
// • Selection indicators → xp (border or accent only)
// • Success → green
// • Warnings → orange

// Default State
Color buttonDefault = brandPrimary; /// #A855F7
BoxShadow buttonDefaultShadow = const BoxShadow(
  color: Color(0x33000000), /// #00000033
  offset: Offset(0, 4),
  blurRadius: 12,
  spreadRadius: 0,
);

// Hover State
Color buttonHover = xpColor; /// #8B47FF
Color buttonHoverOverlay = const Color(0x12FFFFFF); /// #FFFFFF12
BoxShadow buttonHoverShadow = const BoxShadow(
  color: Color(0x4D000000), /// #0000004D
  offset: Offset(0, 8),
  blurRadius: 24,
  spreadRadius: 0,
);

// Active State (pressed)
Color buttonActive = brandPrimary; /// #A855F7
BoxShadow buttonActiveShadow = const BoxShadow(
  color: Color(0x40000000), /// #00000040
  offset: Offset(0, 0),
  blurRadius: 0,
  spreadRadius: 0,
); /// No visible shadow

// Selected State
Color buttonSelected = brandPrimary; /// #A855F7
Color buttonSelectedBorder = xpColor; /// #8B47FF - 1px solid
BoxShadow buttonSelectedShadow = const BoxShadow(
  color: Color(0x33000000), /// #00000033
  offset: Offset(0, 4),
  blurRadius: 12,
  spreadRadius: 0,
);

// Disabled State
Color buttonDisabled = bgTertiary; /// No elevation/shadow

// ============================================================================
// BORDER SYSTEM
// ============================================================================
// BORDER RULES:
// • Default border width: 1px
// • Dividers only use borders (no shadows)
// • Borders use border token (Color(0xff4C4B4D))
// • No borders on primary buttons

// Border Width
const double borderWidthDefault = 1.0; /// Default border width for all borders and dividers

// ============================================================================
// CORNER RADIUS SYSTEM
// ============================================================================
// RADIUS RULES:
// • Small elements (chips, inputs): 8px
// • Buttons & cards: 12px
// • Large containers / modals: 16px
// • Do not mix radius sizes within a component

// Corner Radius
const double radiusSmall = 8.0; /// Small elements (chips, inputs)
const double radiusMedium = 12.0; /// Buttons & cards
const double radiusLarge = 16.0; /// Large containers / modals
