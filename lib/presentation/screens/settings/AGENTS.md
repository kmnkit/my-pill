<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# settings — Settings Screen

## Purpose
User preferences management — language selection, notification settings, display options (high contrast, text size), account management (sign in, delete), and ad removal purchase.

## Key Files

| File | Description |
|------|-------------|
| `settings_screen.dart` | Main settings screen — sections for language, notifications, display, account, remove ads |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Settings-specific widgets — language selector, notification settings, display settings, account section, remove ads banner (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Consumes `settingsProvider` for reading/updating user preferences
- Consumes `authProvider` for account state (anonymous vs signed in)
- Consumes `iapProvider` for remove-ads purchase status
- Language change triggers app-wide locale switch
- Account deletion requires confirmation dialog

### Common Patterns
- Section-based layout with grouped settings
- Toggle switches for boolean settings
- `ref.read(settingsProvider.notifier).updateX()` for mutations

## Dependencies

### Internal
- `data/providers/settings_provider.dart` — User preferences
- `data/providers/auth_provider.dart` — Auth state
- `data/providers/iap_provider.dart` — IAP status
- `settings/widgets/` — Feature-specific widgets
- `presentation/shared/dialogs/` — Confirmation dialogs

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
