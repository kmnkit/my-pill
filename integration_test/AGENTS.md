<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# integration_test — Integration & E2E Tests

## Purpose
End-to-end and integration tests that run the full Flutter app against real or mocked services. Tests are organized using the Page Object / Robot pattern for maintainability.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `flows/` | Test flows organized by user journey (see `flows/AGENTS.md`) |
| `robots/` | Robot pattern helpers — encapsulate screen interactions (see `robots/AGENTS.md`) |
| `utils/` | Test utilities — app setup, mock services, test data (see `utils/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Run integration tests: `flutter test integration_test/`
- Run a specific flow: `flutter test integration_test/flows/home_screen_test.dart`
- Tests use the Robot pattern: flows call robots, robots interact with widgets
- All tests use `utils/test_app.dart` for app bootstrapping with mocked services

### Testing Requirements
- Never use real Firebase in integration tests — use `utils/mock_services.dart`
- Use `utils/test_data.dart` for consistent test fixtures
- Each flow should be independent (no shared mutable state between tests)
- Add `utils/firebase_test_setup.dart` call in `setUpAll` for Firebase mock initialization

### Common Patterns
- `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` at top of each test file
- `app.main()` via `utils/test_app.dart` for app setup
- Robot methods return `this` for fluent chaining: `robot.tapButton().verifyResult()`

## Dependencies

### Internal
- `lib/` — Full app code under test

### External
- `integration_test` — Flutter integration test framework
- `flutter_test` — Widget testing utilities

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
