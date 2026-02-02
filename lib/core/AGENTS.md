<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# core — Design Tokens & Utilities

## Purpose
Application-wide design tokens (colors, typography, spacing), theme configuration, utility functions, and Dart extensions. These are foundational building blocks consumed by the entire app.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `constants/` | Color palette, typography, spacing/sizing constants (see `constants/AGENTS.md`) |
| `extensions/` | Dart extension methods (see `extensions/AGENTS.md`) |
| `theme/` | Material 3 light/dark theme definitions (see `theme/AGENTS.md`) |
| `utils/` | Timezone formatting, error handling utilities (see `utils/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- All design tokens are centralized here — never hardcode colors, fonts, or spacing in screens
- Use `AppColors`, `AppTypography`, `AppSpacing` constants throughout the app
- Theme changes propagate automatically via `AppTheme.light` / `AppTheme.dark`
- This directory has no dependencies on other `lib/` directories (leaf dependency)

### Common Patterns
- Static constant classes (no instantiation)
- Constants use Material 3 design system values
- Typography uses Google Fonts (Lexend family)

## Dependencies

### External
- `google_fonts` — Typography
- `intl` — Date/time formatting

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
