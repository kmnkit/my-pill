# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## App Identity

- **App Name:** Kusuridoki (くすりどき)
- **Package ID:** `com.gingers.mypill`
- **Supported Locales:** English (`en`), Japanese (`ja`)

## Session Initialization

**Serena Plugin**: 이 프로젝트 세션 시작 시 Serena MCP 서버가 활성화되어 있는지 확인하세요. Serena는 Dart LSP 기반 코드 인텔리전스를 제공합니다.

```bash
# Serena 상태 확인
claude mcp list | grep serena

# 비활성화된 경우 활성화
claude mcp add serena -s project -- "$HOME/.local/bin/uvx" --from "git+https://github.com/oraios/serena" serena start-mcp-server
```

Serena 도구: `get_symbols_overview`, `find_symbol`, `find_referencing_symbols`, `search_for_pattern`, `rename_symbol` 등

## Build & Development Commands

```bash
flutter pub get                                                    # Install dependencies
flutter pub run build_runner build --delete-conflicting-outputs    # Generate Freezed models, Riverpod providers, JSON serialization
flutter gen-l10n                                                   # Generate localization files from ARB (lib/l10n/)
flutter run                                                        # Run the app
flutter test                                                       # Run all tests
flutter test test/data/services/adherence_service_test.dart        # Run a single test file
flutter analyze                                                    # Static analysis (flutter_lints)
flutter clean                                                      # Clear build cache (use when builds fail unexpectedly)
flutter build apk --release                                        # Build Android APK
flutter build ios --release                                        # Build iOS (requires macOS)
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

## Environment Setup

**Required files (not in git):**
- `android/app/google-services.json` — Firebase Android config
- `ios/Runner/GoogleService-Info.plist` — Firebase iOS config

**Firebase Emulator (local development):**
```bash
cd functions && npm install
firebase emulators:start --only functions,firestore
```

## Testing

- `mockito` with `@GenerateMocks` for service mocking (run `build_runner` after adding annotations)
- `ProviderContainer` for testing providers, `ProviderScope` wrapper for widget tests
- Existing tests cover: medication inventory logic, adherence rating boundaries, timezone conversions

## Gotchas

- **build_runner 충돌**: `--delete-conflicting-outputs` 플래그 필수
- **Hive 초기화**: `main.dart`에서 모든 TypeAdapter 등록 확인 필요
- **iOS 권한**: 카메라/갤러리 사용 시 `ios/Runner/Info.plist`에 권한 설명 추가
- **Android 권한**: `android/app/src/main/AndroidManifest.xml`에 권한 추가
- **Riverpod 3.x**: `StateProvider` 대신 `NotifierProvider` 사용, `valueOrNull` 없음
