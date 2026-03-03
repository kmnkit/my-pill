<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# widgets — Onboarding Step Widgets

## Purpose
Individual step widgets for the multi-step onboarding flow. Each widget represents one step in the onboarding sequence.

## Key Files

| File | Description |
|------|-------------|
| `onboarding_welcome_step.dart` | Step 1 — Welcome screen with app name and tagline |
| `onboarding_name_step.dart` | Step 2 — User name input |
| `onboarding_role_step.dart` | Step 3 — Role selection (patient / caregiver) |
| `onboarding_timezone_step.dart` | Step 4 — Timezone selection |
| `onboarding_notification_step.dart` | Step 5 — Notification permission request |
| `onboarding_medication_style_step.dart` | Medication style preference step |
| `onboarding_progress_indicator.dart` | Step progress dots indicator |

## For AI Agents

### Working In This Directory
- Steps are stateless widgets receiving callbacks from `OnboardingScreen`
- `onboarding_progress_indicator.dart` shows current step position
- Timezone step uses `TimezoneService` for locale detection
- Notification step calls `NotificationService.requestPermission()`
- All user-visible strings must be localized (EN + JA)

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
