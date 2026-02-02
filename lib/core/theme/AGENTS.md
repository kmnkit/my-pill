<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# theme — Application Themes

## Purpose
Complete Material 3 light and dark theme definitions that compose design tokens from `core/constants/` into Flutter `ThemeData` objects.

## Key Files

| File | Description |
|------|-------------|
| `app_theme.dart` | `AppTheme.light` and `AppTheme.dark` — full Material 3 ThemeData configurations |

## For AI Agents

### Working In This Directory
- Theme values derive from `core/constants/` (AppColors, AppTypography, AppSpacing)
- Both light and dark themes must be maintained in parallel
- Access in widgets via `Theme.of(context)` — don't reference theme files directly
- Material 3 design system (`useMaterial3: true`)

### Common Patterns
- `colorScheme` built from `AppColors`
- `textTheme` from `AppTypography.textTheme`
- Component themes (AppBar, Card, Button, etc.) customized for app brand

## Dependencies

### Internal
- `core/constants/` — Color palette, typography, spacing

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
