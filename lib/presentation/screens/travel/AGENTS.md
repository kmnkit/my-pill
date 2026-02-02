<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# travel — Travel Mode

## Purpose
Timezone-aware medication management for travelers. Displays current/home timezone, shows affected medications, and allows switching between fixed-interval and local-time adjustment modes.

## Key Files

| File | Description |
|------|-------------|
| `travel_mode_screen.dart` | Travel mode dashboard — location display, timezone mode selector, affected medications list |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Travel-specific widgets — location display, affected med list, timezone mode selector (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Consumes `timezoneProvider` for timezone state
- Two modes: `fixedInterval` (keep home timezone schedule) vs `localTime` (adjust to local timezone)
- Shows which medications are affected by timezone change
- Uses `timezone` package for timezone database

### Common Patterns
- `TimezoneMode` enum drives UI toggle
- Location display shows home + current timezone with UTC offset
- Affected medication list with time adjustment preview

## Dependencies

### Internal
- `data/providers/timezone_provider.dart` — Timezone state
- `data/services/timezone_service.dart` — Timezone calculations
- `data/providers/medication_provider.dart` — Medication list
- `travel/widgets/` — Feature-specific widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
