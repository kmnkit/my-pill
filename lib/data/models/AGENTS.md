<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# models — Data Models

## Purpose
Freezed immutable data classes with JSON serialization. These are the core domain entities representing medications, schedules, reminders, adherence records, user profiles, caregiver links, and inventory.

## Key Files

| File | Description |
|------|-------------|
| `medication.dart` | `Medication` — name, dosage, shape, color, photoPath, inventory fields, timestamps |
| `schedule.dart` | `Schedule` — medicationId, type, timesPerDay, times, specificDays, intervalHours, timezoneMode |
| `reminder.dart` | `Reminder` — medicationId, scheduledTime, status, actionTime, snoozedUntil |
| `adherence_record.dart` | `AdherenceRecord` — medicationId, date, status, scheduledTime, actionTime |
| `user_profile.dart` | `UserProfile` — name, email, language, accessibility, notification, travel settings, removeAds |
| `caregiver_link.dart` | `CaregiverLink` — patientId, caregiverId, caregiverName, status, linkedAt |
| `inventory.dart` | `Inventory` — medicationId, total, remaining, lowStockThreshold; computed: isLowStock, percentage |

## For AI Agents

### Working In This Directory
- **CRITICAL**: Run `flutter pub run build_runner build --delete-conflicting-outputs` after ANY change
- Never manually edit `.freezed.dart` or `.g.dart` files
- All models use `@freezed` annotation — immutable with `copyWith`
- All models have `fromJson` / `toJson` via `@JsonSerializable`
- Use `copyWith` for modifications — never mutate directly

### Testing Requirements
- Models can be instantiated directly in tests (no mocking needed)
- Test JSON round-trip serialization for new models

### Common Patterns
- `@Default(value)` for optional fields with defaults
- `DateTime` fields for timestamps
- `String` IDs generated via UUID in repositories
- Computed getters for derived values (e.g., `Inventory.isLowStock`)

## Dependencies

### Internal
- `data/enums/` — Enum types used as model fields

### External
- `freezed_annotation` — Immutable class generation
- `json_annotation` — JSON serialization

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
