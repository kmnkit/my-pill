<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-03-01 -->

# test — Test Suite

## Purpose
Unit and widget tests for the Kusuridoki application. Mirrors the `lib/` directory structure. Covers core utilities, data layer (services, repositories, providers, models, enums), and presentation layer (screens, shared widgets).

## Key Files

| File | Description |
|------|-------------|
| `mock_firebase.dart` | Firebase Auth mock setup — call `setupFirebaseAuthMocks()` in setUp for auth-dependent tests |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `core/` | Core layer tests — constants, extensions, theme, utils (see `core/AGENTS.md`) |
| `data/` | Data layer tests — services, repositories, providers, models, enums (see `data/AGENTS.md`) |
| `helpers/` | Shared test helpers — `createTestableWidget` / `createTestableWidgetJa` (see `helpers/AGENTS.md`) |
| `presentation/` | Widget and screen tests (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Mock library: **mockito** with `@GenerateMocks` annotation
- After adding `@GenerateMocks`: run `dart run build_runner build --delete-conflicting-outputs`
- Use `ProviderContainer` with `overrides` for provider tests
- Widget tests: use `createTestableWidget()` from `test/helpers/widget_test_helpers.dart`
- Auth tests: call `setupFirebaseAuthMocks()` from `test/mock_firebase.dart` in `setUpAll`

### Testing Requirements
- Run `flutter test` — all tests (1470+ pass, ~19 skip)
- Run `flutter test test/path/to/test.dart` for a specific file
- Target: >80% coverage

### Critical Notes
- `kPremiumEnabled = false` — premium-related tests must use `skip: 'kPremiumEnabled is false'`
- Timezone tests: call `tz.initializeTimeZones()` + explicit `setLocalLocation` in setUp
- Notification tests: set `debugDefaultTargetPlatformOverride = TargetPlatform.macOS`

## Dependencies

### Internal
- `lib/` — Source code under test

### External
- `flutter_test` — Flutter testing framework
- `mockito` — Mocking library

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
