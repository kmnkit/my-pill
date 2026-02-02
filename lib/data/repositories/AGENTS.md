<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# repositories — Data Access Abstraction

## Purpose
Repository classes that wrap services with business rules including UUID generation, cascade delete operations, inventory calculations, and schedule time slot generation.

## Key Files

| File | Description |
|------|-------------|
| `medication_repository.dart` | `MedicationRepository` — CRUD with cascade deletes, inventory management (deduct, low stock check, days remaining) |
| `schedule_repository.dart` | `ScheduleRepository` — CRUD with time slot generation, active-on-date checks (daily/specific days/interval) |

## For AI Agents

### Working In This Directory
- Repositories sit between providers and services — they add business rules
- Always use `const Uuid().v4()` for new entity IDs
- Cascade deletes: deleting a medication must also delete its schedules, reminders, and adherence records
- Update `updatedAt` timestamp on all modifications

### Testing Requirements
- Existing tests in `test/data/repositories/medication_repository_test.dart`
- Test business logic (calculations, cascade operations) not just CRUD
- Mock `StorageService` as the dependency

### Common Patterns
- Methods take model parameters and return models
- Search/filter methods for querying subsets
- Computed values (e.g., `daysRemaining`, `isLowStock`)

## Dependencies

### Internal
- `data/services/storage_service.dart` — Data persistence
- `data/models/` — Domain entities
- `data/enums/` — Schedule types for time slot logic

### External
- `uuid` — ID generation

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
