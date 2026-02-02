# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Development Commands

```bash
flutter pub get                                                    # Install dependencies
flutter pub run build_runner build --delete-conflicting-outputs    # Generate Freezed models, Riverpod providers, JSON serialization
flutter gen-l10n                                                   # Generate localization files from ARB (lib/l10n/)
flutter run                                                        # Run the app
flutter test                                                       # Run all tests
flutter test test/data/services/adherence_service_test.dart        # Run a single test file
flutter analyze                                                    # Static analysis (flutter_lints)
```

**After modifying models (`lib/data/models/`) or providers (`lib/data/providers/`)**, you must run `build_runner` — the `.freezed.dart` and `.g.dart` files are auto-generated and must never be manually edited.

**After modifying localization ARB files**, run `flutter gen-l10n`.

## Architecture

Clean Architecture with Riverpod, organized as:

```
lib/
├── main.dart              # Entry: Hive init, Firebase init, ProviderScope
├── app.dart               # MaterialApp.router with themes, localization, GoRouter
├── core/                  # Design tokens (AppColors, AppTypography, AppSpacing), theme, utils
├── data/
│   ├── enums/             # Domain constants with UI metadata (PillShape, PillColor, ScheduleType, etc.)
│   ├── models/            # Freezed immutable data classes (Medication, Schedule, Reminder, etc.)
│   ├── services/          # Business logic + external APIs (StorageService, FirestoreService, AuthService, etc.)
│   ├── repositories/      # Data access with business rules (cascade deletes, UUID generation)
│   └── providers/         # Riverpod state management (@riverpod code-gen)
├── l10n/                  # Auto-generated localization (EN/JA)
└── presentation/
    ├── router/            # GoRouter config with Patient shell (4 tabs) and Caregiver shell (4 tabs)
    ├── screens/           # Feature screens, each with widgets/ subdirectory
    └── shared/            # Reusable Mp-prefixed widgets and dialogs
```

**Data flow:** Enums → Models → Services → Repositories → Providers → Screens

**Dual storage:** `StorageService` (Hive, local-first) and `FirestoreService` (cloud sync) maintain API parity. Services are stateless singletons injected via Riverpod providers.

**Navigation:** GoRouter with two `StatefulShellRoute.indexedStack` shells — Patient mode (`/home`, `/adherence`, `/medications`, `/settings`) and Caregiver mode (`/caregiver/patients`, `/caregiver/notifications`, `/caregiver/alerts`, `/caregiver/settings`). Route names are constants in `RouteNames`.

**Firestore security:** User-scoped read/write, caregivers get read-only access via `caregiverAccess` documents, `invites` and `caregiverAccess` are write-protected (Cloud Functions only).

## Key Conventions

- **Imports**: Always use `package:my_pill/...`, never relative imports
- **Models**: Freezed with `@freezed` — use `copyWith` for mutations, never mutate directly
- **Providers**: Use `@riverpod` annotation, `AsyncNotifier` for mutable state, `ref.invalidateSelf()` after mutations
- **Screens**: `ConsumerWidget`/`ConsumerStatefulWidget`, use `AsyncValue.when()` for loading/error/data
- **Shared widgets**: Prefixed with `Mp` (e.g., `MpButton`, `MpCard`), use `AppColors`/`AppSpacing`/`AppTypography` from `core/constants/`
- **Localization**: All UI strings via `AppLocalizations.of(context)!.key` — supported locales: `en`, `ja`
- **Repositories**: Use `const Uuid().v4()` for new entity IDs, implement cascade deletes (e.g., deleting medication removes its schedules, reminders, adherence records), update `updatedAt` timestamps
- **Enums**: Carry UI metadata (labels, icons, colors) — changes require updating consuming widgets

## Firebase Cloud Functions

`functions/index.js` (Node 18) handles caregiver linking:
- `generateInviteLink` — creates 7-day expiring invite code
- `acceptInvite` — validates and creates bidirectional links via atomic batch writes
- `revokeAccess` — patient-initiated caregiver removal
- `cleanupExpiredInvites` — daily scheduled cleanup

Deploy with `firebase deploy --only functions`.

## Testing

- `mockito` with `@GenerateMocks` for service mocking (run `build_runner` after adding annotations)
- `ProviderContainer` for testing providers, `ProviderScope` wrapper for widget tests
- Existing tests cover: medication inventory logic, adherence rating boundaries, timezone conversions
