<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# enums — Domain Constants

## Purpose
Strongly-typed enums representing domain constants. Each enum includes UI metadata (labels, icons, colors) making them self-describing for presentation.

## Key Files

| File | Description |
|------|-------------|
| `pill_shape.dart` | `PillShape` — round, capsule, oval, square, triangle, hexagon (with `label` and `icon`) |
| `pill_color.dart` | `PillColor` — white, blue, yellow, pink, red, green, orange, purple (with `label` and `color`) |
| `schedule_type.dart` | `ScheduleType` — daily, specificDays, interval |
| `reminder_status.dart` | `ReminderStatus` — pending, taken, missed, skipped, snoozed |
| `dosage_unit.dart` | `DosageUnit` — mg, ml, pills, units |
| `timezone_mode.dart` | `TimezoneMode` — fixedInterval, localTime |

## For AI Agents

### Working In This Directory
- Enums carry UI metadata — changes require updating corresponding widgets
- Adding a new enum value may require UI updates in widgets consuming that enum
- Enums are consumed by models, services, and presentation layers

### Common Patterns
- Each enum has a `label` getter for display text
- Visual enums have `icon` (IconData) or `color` (Color) getters
- Switch statements on enums should be exhaustive

## Dependencies

### External
- `flutter/material.dart` — IconData, Color types

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
