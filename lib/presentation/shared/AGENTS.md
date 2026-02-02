<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# shared — Reusable UI Components

## Purpose
Cross-feature reusable widgets and dialogs with the `Mp` naming prefix. These components enforce consistent design across all screens.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Reusable widgets — buttons, cards, text fields, navigation, medication cards, etc. (see `widgets/AGENTS.md`) |
| `dialogs/` | Reusable dialogs — reminder action dialog, confirmation dialog (see `dialogs/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- All shared components are prefixed with `Mp` (MyPill)
- Use these components in screens — never duplicate UI patterns
- Components use `AppColors`, `AppSpacing`, `AppTypography` from `core/constants/`
- Adding a new shared widget? Prefix with `Mp` and place in `widgets/`

### Common Patterns
- Stateless widgets for pure display
- Callback props for interaction (`onTap`, `onChanged`)
- Theme-aware via `Theme.of(context)`

## Dependencies

### Internal
- `core/constants/` — Design tokens
- `core/theme/` — Theme data
- `data/enums/` — Pill shapes, colors for visual components
- `data/models/` — Model types for data-display widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
