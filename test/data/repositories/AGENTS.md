<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# repositories — Repository Tests

## Purpose
Unit tests for repository business logic including inventory calculations, low stock detection, and days remaining computation.

## Key Files

| File | Description |
|------|-------------|
| `medication_repository_test.dart` | 5 tests — `isLowStock()` threshold checks, `daysRemaining()` calculations, time-based low stock alerts |

## For AI Agents

### Working In This Directory
- Tests instantiate `Medication` models directly (no mocking needed for Freezed models)
- Focus on testing business logic calculations, not CRUD operations
- Test boundary conditions (threshold edges, zero values)

### Common Patterns
- `group('methodName', () { ... })` for organizing
- Direct model instantiation with required fields
- `expect(result, true/false/value)` assertions

## Dependencies

### Internal
- `lib/data/repositories/medication_repository.dart` — Code under test
- `lib/data/models/medication.dart` — Test data

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
