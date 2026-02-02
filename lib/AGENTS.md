<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# lib — Application Source Code

## Purpose
Main Flutter application source code following Clean Architecture with clear separation between core utilities, data layer (models, services, repositories, providers), localization, and presentation (UI screens, widgets, routing).

## Key Files

| File | Description |
|------|-------------|
| `main.dart` | App entry point — initializes Hive, Firebase, wraps app in `ProviderScope` |
| `app.dart` | Root `MaterialApp.router` widget — configures themes, localization, go_router |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `core/` | Design tokens, theme, utilities, extensions (see `core/AGENTS.md`) |
| `data/` | Enums, models, services, repositories, providers (see `data/AGENTS.md`) |
| `l10n/` | Localization — English and Japanese translations (see `l10n/AGENTS.md`) |
| `presentation/` | UI layer — router, screens, shared widgets (see `presentation/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- `main.dart` and `app.dart` are rarely modified — changes here affect the entire app
- Adding new features typically involves: model → service → repository → provider → screen
- All imports should use package syntax: `package:my_pill/...`
- Run `flutter pub run build_runner build --delete-conflicting-outputs` after modifying models or providers

### Testing Requirements
- Unit test services and repositories in `test/data/`
- Widget test screens with `ProviderScope` wrapper

### Common Patterns
- Riverpod `ConsumerWidget` / `ConsumerStatefulWidget` for all screens
- Freezed for immutable data models
- `AsyncValue` for loading/error/data states in UI
- GoRouter for navigation with named routes

## Dependencies

### External
- `flutter_riverpod` — State management
- `go_router` — Routing
- `hive_flutter` — Local storage
- `firebase_core` — Firebase initialization

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
