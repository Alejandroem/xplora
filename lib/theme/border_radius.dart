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
// • Small elements: 8px
// • Buttons & inputs: 12px
// • Large containers / modals: 16px
// • Cards (carousel, profile, featured): 24px
// • Chips & bubbles: pill-shaped (fully circular)
// • Do not mix radius sizes within a component

// Corner Radius
const double radiusSmall = 8.0; /// Small elements
const double radiusMedium = 12.0; /// Buttons & inputs (text fields)
const double radiusLarge = 16.0; /// Large containers / modals
const double radiusCard = 24.0; /// Cards (carousel, profile, featured cards)
const double radiusPill = 100.0; /// Pill-shaped / fully circular elements (chips, filter bubbles, tags)
