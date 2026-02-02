<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# home — Home Screen

## Purpose
Daily medication dashboard showing a personalized greeting, today's medication timeline with reminder actions, and low stock alerts.

## Key Files

| File | Description |
|------|-------------|
| `home_screen.dart` | Main home screen — composes greeting header, medication timeline, and low stock banner |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Home-specific widgets — greeting header, medication timeline, low stock banner (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Consumes `reminderProvider` for today's medication timeline
- Consumes `medicationListProvider` for low stock detection
- Consumes `settingsProvider` for user name in greeting
- Primary entry point for Patient navigation shell

### Common Patterns
- `AsyncValue.when()` for loading/error/data states
- Pull-to-refresh to reload reminders
- Tap on reminder → show `MpReminderDialog` (take/snooze/skip)

## Dependencies

### Internal
- `data/providers/` — reminder, medication, settings providers
- `presentation/shared/widgets/` — shared components
- `home/widgets/` — feature-specific widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
