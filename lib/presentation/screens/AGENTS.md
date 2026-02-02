<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# screens — Feature Screens

## Purpose
Application screens organized by feature domain. Each feature has its own directory containing the main screen and a `widgets/` subdirectory for feature-specific widgets.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `home/` | Daily dashboard — greeting, medication timeline, low stock banner (see `home/AGENTS.md`) |
| `medications/` | Medication CRUD — list, add, detail screens (see `medications/AGENTS.md`) |
| `schedule/` | Schedule configuration — frequency, dosage, intervals (see `schedule/AGENTS.md`) |
| `adherence/` | Adherence reports — weekly summary, charts, breakdown (see `adherence/AGENTS.md`) |
| `settings/` | User preferences — language, notifications, display, account (see `settings/AGENTS.md`) |
| `travel/` | Timezone management — location display, affected medications (see `travel/AGENTS.md`) |
| `caregivers/` | Family linking — caregiver dashboard, QR scanner, patient monitoring (see `caregivers/AGENTS.md`) |
| `onboarding/` | First-launch welcome — language selection, feature highlights (see `onboarding/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Each screen is a `ConsumerWidget` or `ConsumerStatefulWidget`
- Screens consume providers via `ref.watch()` / `ref.read()`
- Feature-specific widgets go in the `widgets/` subdirectory
- Reusable cross-feature widgets go in `presentation/shared/widgets/`
- Use `AsyncValue.when()` for loading/error/data state handling

### Common Patterns
- Screen → `ref.watch(provider)` → `AsyncValue.when(loading:, error:, data:)`
- Actions → `ref.read(provider.notifier).method()`
- Navigation → `context.goNamed(RouteNames.x)` or `context.pushNamed()`

## Dependencies

### Internal
- `data/providers/` — State management
- `data/models/` — Data types
- `data/enums/` — Domain constants
- `core/` — Theme, colors, spacing
- `presentation/shared/` — Reusable widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
