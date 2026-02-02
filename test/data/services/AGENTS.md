<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# services — Service Tests

## Purpose
Unit tests for service logic including adherence rating calculations and timezone conversion utilities.

## Key Files

| File | Description |
|------|-------------|
| `adherence_service_test.dart` | Adherence rating classification — Excellent (95%+), Good (80-94%), Fair (50-79%), Poor (<50%) with boundary tests |
| `timezone_service_test.dart` | Timezone conversions — UTC offset calculation, timezone formatting, NYC-Tokyo difference with DST handling |

## For AI Agents

### Working In This Directory
- Tests are pure unit tests with no external dependencies
- Adherence tests verify boundary conditions at exact percentage thresholds
- Timezone tests account for DST variations (assertions may need seasonal ranges)

### Common Patterns
- `group()` for test organization
- `expect()` with numeric matchers (`closeTo`, exact values)
- Edge case testing at classification boundaries (95.0 vs 94.9)

## Dependencies

### Internal
- `lib/data/services/adherence_service.dart` — Adherence calculations
- `lib/data/services/timezone_service.dart` — Timezone conversions

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
