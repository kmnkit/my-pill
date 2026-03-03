<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# splash — Splash Screen

## Purpose
Initial loading screen shown during app startup. Handles initialization sequencing (Firebase, Hive, auth check) and routes to onboarding or home based on auth state.

## Key Files

| File | Description |
|------|-------------|
| `splash_screen.dart` | SplashScreen — app logo display during initialization |

## For AI Agents

### Working In This Directory
- Splash screen is the first rendered widget after `main.dart` initialization
- GoRouter's `redirect` handles auth-based routing — splash is typically brief
- Do not add heavy logic here; initialization belongs in `main.dart` or service providers

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
