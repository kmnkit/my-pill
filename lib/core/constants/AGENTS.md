<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# constants — Design Token Constants

## Purpose
Centralized design tokens for the entire application: color palette, typography system, and spacing/sizing scale.

## Key Files

| File | Description |
|------|-------------|
| `app_colors.dart` | Color palette — primary teal (#0D968B), status colors, pill colors, semantic colors |
| `app_typography.dart` | Typography system using Google Fonts Lexend — all Material text styles |
| `app_spacing.dart` | Spacing scale (4px-32px), border radii, button sizes, icon sizes |

## For AI Agents

### Working In This Directory
- All values are static constants in utility classes — no instantiation
- Changes here affect the entire app's visual appearance
- Always use these constants in screens/widgets — never hardcode values
- Color values include both light and dark mode variants where applicable

### Common Patterns
- `AppColors.primary` for primary teal color
- `AppTypography.textTheme` for the complete text theme
- `AppSpacing.md` for medium spacing (16px)
- `AppSpacing.radiusMd` for medium border radius

## Dependencies

### External
- `google_fonts` — Lexend font family
- `flutter/material.dart` — Color and TextStyle classes

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
