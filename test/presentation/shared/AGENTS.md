<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# shared — Shared Component Tests

## Purpose
Tests for `lib/presentation/shared/` — reusable `Kd`-prefixed widgets and dialogs.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | KdButton, KdCard, KdTextField and other shared widget tests |
| `dialogs/` | KdConfirmDialog, KdReminderDialog, InventoryUpdateDialog tests |

## For AI Agents

### Working In This Directory
- Shared widget tests are typically pure widget tests (no provider mocking needed)
- Use `createTestableWidget()` from `test/helpers/widget_test_helpers.dart`
- Run: `flutter test test/presentation/shared/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
