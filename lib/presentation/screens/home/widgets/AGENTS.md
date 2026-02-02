<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Home Screen Widgets

## Purpose
Feature-specific widgets for the home screen dashboard including user greeting, medication timeline, and inventory alerts.

## Key Files

| File | Description |
|------|-------------|
| `greeting_header.dart` | `GreetingHeader` — personalized greeting with user name and time-of-day message |
| `medication_timeline.dart` | `MedicationTimeline` — chronological list of today's medication reminders with status |
| `low_stock_banner.dart` | `LowStockBanner` — alert banner for medications running low on inventory |

## For AI Agents

### Working In This Directory
- These widgets are only used by `home_screen.dart`
- Timeline shows reminders grouped by time with take/skip/snooze actions
- Low stock banner links to medication detail for restocking
- Greeting changes based on time of day (morning/afternoon/evening)

## Dependencies

### Internal
- `data/models/` — Reminder, Medication models
- `presentation/shared/widgets/` — MpCard, MpBadge, MpAlertBanner
- `core/constants/` — Design tokens

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
