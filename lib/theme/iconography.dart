import 'package:flutter/material.dart';

// ============================================================================
// ICONOGRAPHY SYSTEM (MVP)
// ============================================================================
// ICON RULES:
// • Icons are functional, not decorative
// • Icons always accompany text (no icon-only actions in MVP)
// • Stroke-based icons preferred over filled
// • Icons inherit text color tokens (textPrimary, textSecondary, textTertiary)
// • No custom icons in MVP (use system/library icons only)
// • Icon sizes: 16 / 20 / 24 px only

// Icon Sizes
const double iconSizeSmall = 16.0; /// Small icons (e.g., inline with text)
const double iconSizeMedium = 20.0; /// Medium icons (e.g., buttons, form fields)
const double iconSizeLarge = 24.0; /// Large icons (e.g., prominent actions)

// NOTE: Icons do not have separate colors
// Icons inherit text color tokens based on hierarchy:
// • Primary icons → textPrimary
// • Secondary icons → textSecondary
// • Tertiary icons → textTertiary

// ============================================================================
// AVATAR SIZES
// ============================================================================
// Avatar/Profile Picture Sizes
const double avatarRadiusSmall = 18.0; /// Small avatar radius (used in CircleAvatar)
const double avatarSizeSmall = 36.0; /// Small avatar diameter (width/height for images)
