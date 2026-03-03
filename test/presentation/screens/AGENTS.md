<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# screens — Screen Tests

## Purpose
Widget tests for all feature screens, organized by feature domain. Each subdirectory mirrors `lib/presentation/screens/`.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `adherence/` | Weekly summary screen and adherence widget tests |
| `caregivers/` | Caregiver dashboard, QR scanner tests |
| `home/` | Home screen and timeline widget tests |
| `medications/` | Medication list screen tests |
| `schedule/` | Schedule screen and widget tests |
| `settings/` | Settings screen and widget tests |
| `travel/` | Travel mode screen and widget tests |

## For AI Agents

### Working In This Directory
- Use `createTestableWidget()` from `test/helpers/widget_test_helpers.dart`
- Each test file should test one screen or feature widget
- Mock all Riverpod providers via `overrides`
- Run: `flutter test test/presentation/screens/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
