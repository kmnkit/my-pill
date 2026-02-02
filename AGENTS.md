<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# MyPill - Medication Management App

## Purpose
A cross-platform Flutter application for medication management targeting Japanese and English-speaking markets. Provides medication scheduling, inventory tracking, adherence monitoring, caregiver linking, and timezone-aware travel support. Built with a local-first architecture (Hive) with optional Firebase cloud sync.

## Key Files

| File | Description |
|------|-------------|
| `pubspec.yaml` | Project dependencies and metadata (Flutter, Dart SDK >=3.10.8) |
| `pubspec.lock` | Locked dependency versions |
| `analysis_options.yaml` | Dart analyzer and linter configuration (flutter_lints) |
| `firestore.rules` | Firestore security rules (user-scoped access, caregiver read-only) |
| `firestore.indexes.json` | Firestore composite index definitions (currently empty) |
| `l10n.yaml` | Internationalization config (ARB source, template: app_en.arb) |
| `my_pill.iml` | IntelliJ module file |
| `README.md` | Project README |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `lib/` | Flutter application source code (see `lib/AGENTS.md`) |
| `test/` | Unit and widget tests (see `test/AGENTS.md`) |
| `functions/` | Firebase Cloud Functions for caregiver linking (see `functions/AGENTS.md`) |
| `docs/` | Product requirements documents in EN/JA (see `docs/AGENTS.md`) |
| `assets/` | Static assets — icons and images (see `assets/AGENTS.md`) |
| `android/` | Android platform-specific code and configuration |
| `ios/` | iOS platform-specific code and configuration |

## For AI Agents

### Working In This Directory

- **Architecture**: Clean Architecture with Riverpod state management
- **State Management**: Riverpod 3.x with code generation (`riverpod_annotation`)
- **Data Models**: Freezed + json_serializable (immutable, with `copyWith`)
- **Navigation**: go_router with StatefulShellRoute for bottom navigation
- **Storage**: Hive (local-first) + Firestore (optional cloud sync)
- **Localization**: English (`en`) and Japanese (`ja`) via ARB files
- **Monetization**: AdMob banner/interstitial + IAP (remove ads)

### Build Commands

| Command | Purpose |
|---------|---------|
| `flutter pub get` | Install dependencies |
| `flutter pub run build_runner build --delete-conflicting-outputs` | Generate Freezed models, Riverpod providers, JSON serialization |
| `flutter gen-l10n` | Generate localization files from ARB |
| `flutter run` | Run the app |
| `flutter test` | Run all tests |
| `flutter analyze` | Run static analysis |

### Testing Requirements

- Run `flutter test` before committing
- Use `mockito` for mocking services
- Test repositories and services independently
- Widget tests should wrap in `ProviderScope`

### Common Patterns

- **File naming**: `snake_case.dart`
- **Class naming**: `PascalCase`
- **Shared widgets**: Prefixed with `Mp` (e.g., `MpButton`)
- **Providers**: `camelCase` with descriptive names (e.g., `medicationListProvider`)
- **Imports**: Use package imports (`package:my_pill/...`), not relative
- **Never edit** `.freezed.dart` or `.g.dart` files — they are auto-generated

### Common Pitfalls

- Forgetting to run `build_runner` after model/provider changes
- Directly instantiating services instead of using Riverpod providers
- Hardcoding UI strings instead of using `AppLocalizations`
- Not implementing cascade deletes in repositories
- Mutating Freezed models directly (use `copyWith` instead)

## Dependencies

### External (Key Packages)

| Package | Purpose |
|---------|---------|
| `flutter_riverpod` | State management |
| `go_router` | Declarative routing |
| `hive_flutter` | Local NoSQL storage |
| `firebase_core/auth/firestore/messaging` | Firebase services |
| `freezed_annotation` / `json_annotation` | Code generation annotations |
| `google_fonts` | Typography (Lexend) |
| `fl_chart` | Adherence charts |
| `google_mobile_ads` | AdMob integration |
| `in_app_purchase` | IAP for ad removal |
| `flutter_local_notifications` | Local push notifications |
| `timezone` | Timezone handling |
| `app_links` | Deep linking |
| `home_widget` | Native home screen widgets |
| `qr_flutter` / `mobile_scanner` | QR code generation/scanning |

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
