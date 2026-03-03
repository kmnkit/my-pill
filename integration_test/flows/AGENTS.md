<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# flows — Integration Test Flows

## Purpose
End-to-end test flows organized by user journey. Each file tests a complete user scenario using robot helpers from `../robots/`.

## Key Files

| File | Description |
|------|-------------|
| `adherence_screen_test.dart` | Weekly adherence summary screen flow |
| `caregiver_dashboard_test.dart` | Caregiver dashboard and patient monitoring flow |
| `home_screen_test.dart` | Home screen daily medication timeline flow |
| `medication_add_test.dart` | Add new medication end-to-end flow |
| `medication_detail_test.dart` | Medication detail view and edit flow |
| `onboarding_test.dart` | First-launch onboarding flow |
| `schedule_screen_test.dart` | Schedule configuration flow |
| `settings_screen_test.dart` | Settings screen interactions flow |
| `travel_mode_test.dart` | Travel mode timezone adjustment flow |

## For AI Agents

### Working In This Directory
- Each test file should test one complete user journey
- Use robot helpers from `../robots/` for screen interactions
- Call `tester.pumpAndSettle()` after navigation and async operations
- Avoid `sleep()` — use `pump(Duration)` or `pumpAndSettle()`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
