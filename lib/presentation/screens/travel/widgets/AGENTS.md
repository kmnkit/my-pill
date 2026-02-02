<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Travel Mode Widgets

## Purpose
Feature-specific widgets for travel mode including timezone location display, affected medication list, and timezone handling mode selector.

## Key Files

| File | Description |
|------|-------------|
| `location_display.dart` | `LocationDisplay` — shows home and current timezone with UTC offset and abbreviation |
| `affected_med_list.dart` | `AffectedMedList` — medications affected by timezone change with time adjustment preview |
| `timezone_mode_selector.dart` | `TimezoneModeSelector` — toggle between fixed-interval and local-time modes |

## For AI Agents

### Working In This Directory
- Location display formats timezone using `TimezoneService.formatTimezone()` (e.g., "JST +9")
- Affected med list shows original vs adjusted times for each medication
- Mode selector explains the difference between fixed-interval and local-time

## Dependencies

### Internal
- `data/providers/timezone_provider.dart` — Timezone state
- `data/services/timezone_service.dart` — Formatting utilities
- `data/enums/timezone_mode.dart` — Mode enum
- `core/constants/` — Design tokens

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
