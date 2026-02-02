<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# presentation — UI Layer

## Purpose
Complete UI layer following MVVM with Riverpod. Contains the router configuration, all application screens organized by feature, and shared reusable widgets/dialogs. Supports two navigation shells: Patient mode (4 tabs) and Caregiver mode (4 tabs).

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `router/` | GoRouter configuration and named route constants (see `router/AGENTS.md`) |
| `screens/` | Feature screens — home, medications, schedule, adherence, settings, travel, caregivers, onboarding (see `screens/AGENTS.md`) |
| `shared/` | Reusable widgets and dialogs with `Mp` prefix (see `shared/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- All screens are `ConsumerWidget` or `ConsumerStatefulWidget` (Riverpod)
- Use shared widgets from `shared/widgets/` — never duplicate UI components
- Use `AppSpacing` for padding/margins, `AppColors` for colors
- Navigation via GoRouter — use `RouteNames` constants for route references
- Use `AppLocalizations.of(context)!` for all user-visible strings

### Testing Requirements
- Widget tests must wrap in `ProviderScope` with mocked providers
- Test screen states: loading, data, error, empty

### Common Patterns
- `AsyncValue.when()` for handling loading/error/data states
- `ref.watch()` for reactive provider consumption
- `ref.read()` for one-time actions (button handlers)
- Bottom navigation via `StatefulShellRoute.indexedStack`

## Dependencies

### Internal
- `core/` — Theme, colors, spacing, typography
- `data/providers/` — State management
- `data/models/` — Data types
- `data/enums/` — Domain constants

### External
- `go_router` — Routing
- `flutter_riverpod` — State management
- `fl_chart` — Adherence charts
- `qr_flutter` / `mobile_scanner` — QR code features
- `image_picker` — Photo selection

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
