<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# core — Core Layer Tests

## Purpose
Unit tests for the `lib/core/` layer — design tokens, theme, utilities, and extension methods.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `constants/` | Tests for AppTypography, AppColors, AppSpacing constants |
| `extensions/` | Tests for Dart extension methods |
| `theme/` | Tests for AppTheme and GlassDecoration |
| `utils/` | Tests for utility functions — error handler, auth errors, encryption, scrubber |

## For AI Agents

### Working In This Directory
- Core layer tests have no Firebase dependencies
- No mocking required for pure Dart utility tests
- Run: `flutter test test/core/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
