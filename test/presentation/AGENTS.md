<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# presentation — Presentation Layer Tests

## Purpose
Widget and screen tests for `lib/presentation/` — verifies UI rendering, user interactions, navigation, and state-driven display.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `router/` | Router and navigation tests |
| `screens/` | Screen-level widget tests organized by feature |
| `shared/` | Shared widget and dialog tests (see `shared/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- All widget tests use `createTestableWidget()` from `test/helpers/widget_test_helpers.dart`
- Mock all provider dependencies via `overrides` parameter
- Test loading, data, and error states for each screen
- Run: `flutter test test/presentation/`

### Critical Setup
- `setupFirebaseAuthMocks()` in `setUpAll` for any test touching auth providers
- `debugDefaultTargetPlatformOverride = TargetPlatform.macOS` for notification tests
- Restore with `addTearDown(() => debugDefaultTargetPlatformOverride = null)`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
