<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Settings Screen Widgets

## Purpose
Feature-specific widgets for the settings screen including language selection, notification preferences, display options, account management, and ad removal.

## Key Files

| File | Description |
|------|-------------|
| `language_selector.dart` | `LanguageSelector` — English/Japanese toggle |
| `notification_settings.dart` | `NotificationSettings` — notification preferences (snooze duration, critical alerts) |
| `display_settings.dart` | `DisplaySettings` — high contrast toggle, text size adjustment |
| `account_section.dart` | `AccountSection` — sign in/out, account deletion, email linking |
| `remove_ads_banner.dart` | `RemoveAdsBanner` — IAP purchase prompt for ad removal |

## For AI Agents

### Working In This Directory
- Language change triggers full app locale switch via `settingsProvider`
- Account section adapts based on auth state (anonymous shows sign-in, authenticated shows sign-out/delete)
- Remove ads banner hidden when user has already purchased
- High contrast mode affects app-wide theme

## Dependencies

### Internal
- `data/providers/settings_provider.dart` — Preference updates
- `data/providers/auth_provider.dart` — Auth state
- `data/providers/iap_provider.dart` — Purchase status
- `presentation/shared/widgets/` — MpToggleSwitch, MpButton
- `core/constants/` — Design tokens

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
