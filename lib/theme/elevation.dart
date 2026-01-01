import 'package:flutter/material.dart';

// ============================================================================
// ELEVATION SYSTEM
// ============================================================================
// ELEVATION RULES:
// • Use elevation to establish visual hierarchy
// • Higher elevation = more prominent element
// • Disabled elements do not receive elevation
// • Modal overlays use the highest elevation

// Elevation Levels
const BoxShadow elevationNone = BoxShadow(
  color: Color(0x00000000), /// Transparent
  offset: Offset(0, 0),
  blurRadius: 0,
  spreadRadius: 0,
); /// No elevation

const BoxShadow elevation1 = BoxShadow(
  color: Color(0x33000000), /// #00000033
  offset: Offset(0, 4),
  blurRadius: 12,
  spreadRadius: 0,
); /// Level 1 - Subtle elevation for cards and containers

const BoxShadow elevation2 = BoxShadow(
  color: Color(0x4D000000), /// #0000004D
  offset: Offset(0, 8),
  blurRadius: 24,
  spreadRadius: 0,
); /// Level 2 - Medium elevation for hover states and floating elements

const BoxShadow elevation3 = BoxShadow(
  color: Color(0x59000000), /// #00000059
  offset: Offset(0, 12),
  blurRadius: 32,
  spreadRadius: 0,
); /// Level 3 - High elevation for modals and popups
