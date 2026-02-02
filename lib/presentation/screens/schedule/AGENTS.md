<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# schedule — Schedule Configuration

## Purpose
Medication schedule setup — frequency selection (daily/specific days/interval), dosage multiplier, time slot picking, and interval configuration.

## Key Files

| File | Description |
|------|-------------|
| `schedule_screen.dart` | Schedule configuration form — type selection, time slots, interval settings |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Schedule-specific widgets — frequency selector, day selector, time slot picker, etc. (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Schedule is linked to a medication via `medicationId`
- Three schedule types: `daily` (X times/day), `specificDays` (select weekdays), `interval` (every N hours)
- Time slots are stored as `List<String>` in HH:mm format
- Accessed via sub-route `/medications/:id/schedule`

### Common Patterns
- `ScheduleType` enum drives UI conditionally (show different pickers per type)
- Time picker widgets for each time slot
- Day selector for specific-days mode (checkboxes for Mon-Sun)

## Dependencies

### Internal
- `data/providers/schedule_provider.dart` — Schedule CRUD
- `data/models/schedule.dart` — Schedule model
- `data/enums/schedule_type.dart` — Schedule type enum
- `schedule/widgets/` — Feature-specific widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
