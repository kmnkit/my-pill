<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# widgets — Shared Widget Tests

## Purpose
Tests for `lib/presentation/shared/widgets/` — KdButton, KdCard, KdTextField, KdPillIcon, KdBottomNavBar, and other `Kd`-prefixed widgets.

## For AI Agents

### Working In This Directory
- Shared widget tests verify rendering, props, callbacks, and theme variants
- Most tests are pure widget tests — no provider mocking needed
- Run: `flutter test test/presentation/shared/widgets/`

### Testing Checklist for New Widgets
- [ ] Renders correctly with default props
- [ ] Callbacks fire on user interaction
- [ ] Handles null/empty prop values gracefully
- [ ] Renders in both light and dark theme

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
