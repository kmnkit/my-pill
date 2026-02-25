<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Schedule Screen Widgets

## Purpose
Feature-specific widgets for schedule configuration including frequency selection, day picking, time slot management, and interval settings.

## Key Files

| File | Description |
|------|-------------|
| `frequency_selector.dart` | `FrequencySelector` — times-per-day selection for daily schedules |
| `interval_picker.dart` | `IntervalPicker` — hour interval selection for interval-based schedules |
| `day_selector.dart` | `DaySelector` — weekday checkboxes for specific-days schedules (Mon-Sun) |

## For AI Agents

### Working In This Directory
- Widget visibility depends on `ScheduleType` — not all widgets show for all types
- `daily` → FrequencySelector + DosageTimingSelector + DosageTimeAdjuster
- `specificDays` → DaySelector + DosageTimingSelector + DosageTimeAdjuster
- `interval` → IntervalPicker
- Dosage times managed via `DosageTiming` enum and `DosageTimeSlot` model

## Dependencies

### Internal
- `data/enums/schedule_type.dart` — Conditional rendering logic
- `presentation/shared/widgets/` — MpTimePicker, MpButton
- `core/constants/` — Design tokens

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
