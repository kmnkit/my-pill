<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-03-01 -->

# assets — Static Assets

## Purpose
Static assets bundled with the Flutter application — custom fonts, UI icons, app images, and App Store marketing screenshots.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `fonts/` | Custom fonts — NotoSansJP-Regular.ttf for Japanese text |
| `icons/` | App icon, Google logo, LINE logo for UI elements |
| `images/` | Application images (e.g., screenshot.png) |
| `marketing/` | Marketing assets container |
| `marketing/screenshots/` | App Store / Play Store screenshot images (01–08 + current) |

## For AI Agents

### Working In This Directory
- All assets must be declared in `pubspec.yaml` under `assets:` or `fonts:` section
- After adding new assets, run `flutter pub get`
- Asset paths in code: `assets/icons/filename.png`, `assets/fonts/Font.ttf`
- **Google sign-in button**: always use `assets/icons/google-logo.png` (see `~/.claude/rules/google-login.md`)
- Marketing screenshots: named `{nn}_{feature}.png` — used for App Store submissions

### Common Patterns
- `Image.asset('assets/icons/app_icon.png')` — PNG image rendering
- `AssetImage('assets/icons/app_icon.png')` — decoration/avatar usage
- Font registration in `pubspec.yaml` uses `family:` + `asset:` under `fonts:`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
