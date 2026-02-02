<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# dialogs — Shared Dialogs

## Purpose
Reusable dialog components for user confirmations and reminder actions. Follow the `Mp` naming convention.

## Key Files

| File | Description |
|------|-------------|
| `mp_reminder_dialog.dart` | `MpReminderDialog` — reminder action sheet with Take/Snooze/Skip options |
| `mp_confirm_dialog.dart` | `MpConfirmDialog` — generic confirmation dialog with title, message, confirm/cancel actions |

## For AI Agents

### Working In This Directory
- Dialogs are shown via `showDialog()` or `showModalBottomSheet()`
- `MpReminderDialog` returns the selected action (taken/snoozed/skipped)
- `MpConfirmDialog` returns `true` (confirmed) or `false` (cancelled)
- Use `AppColors` and `AppSpacing` for consistent styling

### Common Patterns
- Return values via `Navigator.pop(context, result)`
- Async usage: `final result = await showDialog<ActionType>(...)`
- Destructive actions use red/warning colors

## Dependencies

### Internal
- `core/constants/` — Design tokens
- `data/enums/reminder_status.dart` — Reminder action types

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
