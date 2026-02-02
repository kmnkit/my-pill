<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# providers — Riverpod State Management

## Purpose
Riverpod providers managing application state. Uses code generation (`@riverpod` annotation) for type-safe providers. Covers medications, schedules, reminders, settings, adherence, auth, caregivers, timezone, ads, IAP, and deep links.

## Key Files

| File | Description |
|------|-------------|
| `storage_service_provider.dart` | Singleton `StorageService` instance |
| `medication_provider.dart` | `AsyncNotifierProvider` — medication list with add/update/delete |
| `schedule_provider.dart` | `AsyncNotifierProvider` — schedule list with CRUD |
| `reminder_provider.dart` | `AsyncNotifierProvider` — today's reminders with take/skip/snooze |
| `settings_provider.dart` | `AsyncNotifierProvider` — user profile with update methods |
| `adherence_provider.dart` | `FutureProvider` — adherence calculations and ratings |
| `auth_provider.dart` | `Provider` + `StreamProvider` — auth service and auth state stream |
| `caregiver_provider.dart` | `AsyncNotifierProvider` — caregiver link management |
| `caregiver_monitoring_provider.dart` | `StreamProvider` — real-time patient data for caregivers |
| `timezone_provider.dart` | `NotifierProvider` — timezone settings state |
| `deep_link_provider.dart` | `StreamProvider` — deep link invite codes |
| `home_widget_provider.dart` | `Provider` — home widget service instance |
| `ad_provider.dart` | `Provider` — ad service instance |
| `iap_provider.dart` | `Provider` — IAP service instance |

## For AI Agents

### Working In This Directory
- **CRITICAL**: Run `flutter pub run build_runner build --delete-conflicting-outputs` after ANY change
- Never manually edit `.g.dart` generated files
- Use `@riverpod` annotation for new providers
- Providers with mutations use `AsyncNotifier` pattern
- Read-only data uses `FutureProvider` or `StreamProvider`
- Use `ref.invalidateSelf()` to refresh state after mutations

### Testing Requirements
- Test with `ProviderContainer` and overrides for mocked dependencies
- Verify state transitions: loading → data, loading → error

### Common Patterns
- `AsyncNotifierProvider` for mutable collections (CRUD)
- `FutureProvider` for computed/derived data
- `StreamProvider` for real-time Firebase streams
- `Provider` for singleton service instances
- Providers `watch` other providers for reactive composition

## Dependencies

### Internal
- `data/services/` — All service classes
- `data/repositories/` — Business logic layer
- `data/models/` — Domain entities

### External
- `flutter_riverpod` / `riverpod_annotation` — State management framework

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
