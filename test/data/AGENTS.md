<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# data — Data Layer Tests

## Purpose
Unit tests for the data layer including repository logic and service calculations. Mirrors the structure of `lib/data/`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `repositories/` | Repository unit tests (see `repositories/AGENTS.md`) |
| `services/` | Service unit tests (see `services/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Test files mirror `lib/data/` structure
- Use `mockito` with `@GenerateMocks` for mocking dependencies
- Each test file should test one source file
- Run `flutter pub run build_runner build` after adding new `@GenerateMocks` annotations

### Testing Requirements
- Run `flutter test test/data/` to execute all data layer tests
- Cover both happy paths and edge cases
- Test boundary conditions (e.g., 0 values, empty lists, null states)

### Common Patterns
- `group()` blocks for organizing related assertions
- Direct instantiation of models for test data (no mocks needed for Freezed models)
- Assert with `expect(actual, expected)` using matchers

## Dependencies

### Internal
- `lib/data/` — Source code under test

### External
- `flutter_test` — Testing framework
- `mockito` — Mocking

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
