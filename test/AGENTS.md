<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# test — Test Suite

## Purpose
Unit and widget tests for the MyPill application. Tests cover data layer logic including repository calculations, service rating systems, and timezone conversions.

## Key Files

| File | Description |
|------|-------------|
| `widget_test.dart` | Placeholder smoke test (to be expanded) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `data/` | Data layer tests (see `data/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Use `mockito` for mocking services and dependencies
- Test files mirror the `lib/` directory structure
- Each test file should correspond to a source file in `lib/`
- Use `ProviderContainer` for testing Riverpod providers
- Widget tests must wrap in `ProviderScope`

### Testing Requirements
- Run `flutter test` to execute all tests
- Run `flutter test test/path/to/specific_test.dart` for individual tests
- Aim for >80% coverage on services and repositories

### Common Patterns
- `group()` for organizing related tests
- `setUp()` / `tearDown()` for test fixtures
- Mock objects created with `@GenerateMocks` annotation
- Assertion style: `expect(actual, matcher)`

## Dependencies

### Internal
- `lib/data/` — Source code under test

### External
- `flutter_test` — Flutter testing framework
- `mockito` — Mocking library

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
