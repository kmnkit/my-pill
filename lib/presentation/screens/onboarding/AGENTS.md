<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# onboarding — Welcome Screen

## Purpose
First-launch onboarding experience with language selection (English/Japanese) and feature highlights introducing the app's key capabilities.

## Key Files

| File | Description |
|------|-------------|
| `onboarding_screen.dart` | Welcome screen — language selector, feature highlights carousel, get started action |

## For AI Agents

### Working In This Directory
- Shown only on first app launch (controlled via user profile settings)
- Language selection here sets the app locale globally
- After onboarding, navigates to home screen and marks onboarding as complete
- No `widgets/` subdirectory — all UI is self-contained in the screen

### Common Patterns
- PageView or similar for feature highlights
- Language toggle updates `settingsProvider`
- One-time screen — not accessible from normal navigation

## Dependencies

### Internal
- `data/providers/settings_provider.dart` — Language/profile updates
- `presentation/shared/widgets/` — Shared UI components

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
