<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# utils — Utility Functions

## Purpose
Shared utility functions for timezone formatting and user-friendly error message generation.

## Key Files

| File | Description |
|------|-------------|
| `timezone_utils.dart` | `formatTime()`, `formatDualTime()`, `formatOffset()` — time display helpers |
| `error_handler.dart` | `ErrorHandler.getMessage(Object error)` — converts exceptions to readable strings |

## For AI Agents

### Working In This Directory
- Utilities are pure functions or static methods — no state
- Error handler covers common Firebase and network exceptions
- Timezone utils format times for display (not business logic — see `data/services/timezone_service.dart` for that)

### Common Patterns
- Static methods on utility classes
- No side effects — pure input/output

## Dependencies

### External
- `intl` — Date/time formatting

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
