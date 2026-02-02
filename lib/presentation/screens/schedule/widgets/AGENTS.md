<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Schedule Screen Widgets

## Purpose
Feature-specific widgets for schedule configuration including frequency selection, day picking, time slot management, and interval settings.

## Key Files

| File | Description |
|------|-------------|
| `frequency_selector.dart` | `FrequencySelector` — times-per-day selection for daily schedules |
| `dosage_multiplier.dart` | `DosageMultiplier` — dosage amount per intake adjustment |
| `interval_picker.dart` | `IntervalPicker` — hour interval selection for interval-based schedules |
| `day_selector.dart` | `DaySelector` — weekday checkboxes for specific-days schedules (Mon-Sun) |
| `time_slot_picker.dart` | `TimeSlotPicker` — add/remove/edit time slots for medication times |

## For AI Agents

### Working In This Directory
- Widget visibility depends on `ScheduleType` — not all widgets show for all types
- `daily` → FrequencySelector + TimeSlotPicker
- `specificDays` → DaySelector + TimeSlotPicker
- `interval` → IntervalPicker
- Time slots stored as `List<String>` in HH:mm format

## Dependencies

### Internal
- `data/enums/schedule_type.dart` — Conditional rendering logic
- `presentation/shared/widgets/` — MpTimePicker, MpButton
- `core/constants/` — Design tokens

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
