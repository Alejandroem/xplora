import 'package:flutter/material.dart';
import 'colors.dart';
import 'dark_colors.dart';
import 'light_colors.dart';

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

// Disabled State (Dark Mode)
Color buttonDisabledDark = bgTertiaryDark; /// #363538 - No elevation/shadow

// Disabled State (Light Mode)
Color buttonDisabledLight = bgTertiaryLight; /// #DADADA - No elevation/shadow

// Quest List Tile Splash State (Dark Mode)
Color questSplashDark = const Color(0xFF414141); /// #414141 - Quest item press overlay

// Quest List Tile Splash State (Light Mode)
Color questSplashLight = const Color(0x14000000); /// #00000014 - Quest item press overlay

// Switch Active State Glow
BoxShadow switchActiveGlow = BoxShadow(
  color: const Color(0xFFA855F7).withValues(alpha: 0.1), /// brandPrimary with 15% opacity
  offset: const Offset(0, 0),
  blurRadius: 8,
  spreadRadius: 0,
); /// Glow effect for active switch state
