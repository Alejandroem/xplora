# Claude Instructions – Flutter Design System Enforcement

## Project Context
This is a **gamified travel application built in Flutter** where users:
- Visit real-world places
- Complete quests associated with places
- Earn XP and progress through the app

The app is currently undergoing a **full UI/UX redesign** based on a client-provided **design system**.

Your primary responsibility when generating, modifying, or refactoring code is to **strictly follow this design system**.

---

## 🚨 NON-NEGOTIABLE RULE
**NEVER introduce custom styling, colors, typography, spacing, radius, elevation, or states outside the design system.**

If something is missing from the design system:
- Reuse the closest existing token
- OR ask explicitly before inventing anything new

---

## Design System Structure (Single Source of Truth)

The design system is implemented in the following files.  
You must **always reference these instead of hardcoding values**.

### 🎨 Colors
- `colors.dart` → Common brand colors (primary, secondary, etc.)
- `light_colors.dart` → Light theme color scheme
- `dark_colors.dart` → Dark theme color scheme

Rules:
- Do NOT hardcode `Color(...)`
- Do NOT use raw hex values
- Always use semantic colors from the theme or design tokens

---

### 📝 Typography
- `typography.dart`

Rules:
- Use only predefined text styles
- Do NOT create new `TextStyle` inline
- Use semantic naming (e.g. heading, body, caption)

---

### 📏 Spacing & Layout
- `spacing.dart`

Rules:
- All padding, margin, gaps, and layout spacing must come from here
- Never use magic numbers like `8`, `16`, `24`

---

### 📦 Elevation
- `elevation.dart`

Rules:
- All shadows and elevations must reference this file
- No inline `BoxShadow` or `elevation:` values

---

### 🧭 States (Interaction Rules)
- `states.dart`

Includes:
- Button states (default, pressed, hovered, disabled)
- Other component interaction states

Rules:
- UI must visually reflect states defined here
- No ad-hoc pressed/hover logic

---

### 🧩 Iconography
- `iconography.dart`

Rules:
- Use only defined rules

---

### 🔲 Borders & Radius
- `border_radius.dart`

Rules:
- All corner radius values must come from this file
- No inline `BorderRadius.circular(...)`

---

## 🌗 Theme Handling
The app supports **Light & Dark Mode** using Flutter `MaterialApp` themes.

Rules:
- Components must be theme-aware
- Do NOT manually check for dark/light mode inside widgets
- Always rely on theme tokens

---

## Component & Screen Rules

When modifying or creating:
- Screens
- Widgets
- Components
- Buttons
- Cards
- Lists
- Dialogs
- Bottom sheets

You must:
1. Use **only** design system tokens
2. Refactor existing non-compliant widgets
3. Replace hardcoded values with system values
4. Maintain consistency across the app

---

## Refactoring Legacy Code
When encountering widgets that do NOT follow the design system:
- Refactor them to comply
- Do not preserve old styles for backward compatibility
- Assume the design system is the new standard

---

## Expected Output Quality
Your output should be:
- Clean
- Consistent
- Scalable
- Token-driven
- Easy to theme
- Easy to maintain

---

## If Instructions Are Ambiguous
If a UI requirement is unclear:
- Prefer design system consistency over assumptions
- Ask a clarifying question **only if necessary**

---

## Summary
You are not just writing Flutter UI.
You are enforcing a **design system contract**.

Breaking the design system = incorrect output.