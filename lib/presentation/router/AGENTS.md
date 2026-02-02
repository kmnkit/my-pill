<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# router — Navigation Configuration

## Purpose
GoRouter configuration with two navigation shells (Patient and Caregiver modes), named route constants, and all route definitions.

## Key Files

| File | Description |
|------|-------------|
| `app_router.dart` | GoRouter setup — Patient shell (Home, Adherence, Medications, Settings), Caregiver shell (Patients, Notifications, Alerts, Settings), standalone routes (onboarding, invite) |
| `route_names.dart` | `RouteNames` — static string constants for all named routes |

## For AI Agents

### Working In This Directory
- Adding a new screen requires: adding a route in `app_router.dart` + a constant in `route_names.dart`
- Patient shell uses `StatefulShellRoute.indexedStack` for persistent bottom navigation (4 tabs)
- Caregiver shell has separate 4-tab bottom navigation
- Sub-routes (e.g., `/medications/add`, `/medications/:id`) nest under shell routes
- Always use `RouteNames` constants — never hardcode route strings

### Key Routes
- **Patient**: `/home`, `/adherence`, `/medications`, `/settings`
- **Caregiver**: `/caregiver/patients`, `/caregiver/notifications`, `/caregiver/alerts`, `/caregiver/settings`
- **Standalone**: `/onboarding`, `/invite/:code`
- **Sub-routes**: `/medications/add`, `/medications/:id`, `/medications/:id/schedule`

### Common Patterns
- `GoRoute(name: RouteNames.x, path: '/x', builder: ...)` for route definitions
- `context.goNamed(RouteNames.x)` for navigation
- Path parameters via `:id` syntax

## Dependencies

### Internal
- `presentation/screens/` — All screen widgets
- `presentation/shared/widgets/` — Bottom nav bar

### External
- `go_router` — Routing framework

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
