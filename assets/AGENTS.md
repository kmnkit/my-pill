<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# assets — Static Assets

## Purpose
Container for application icons and images. Currently placeholder directories prepared for future asset additions.

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `icons/` | App icons and UI iconography (currently empty) |
| `images/` | Application images and illustrations (currently empty) |

## For AI Agents

### Working In This Directory
- Assets are referenced in `pubspec.yaml` under the `assets:` section
- When adding new assets, ensure they are registered in `pubspec.yaml`
- Use SVG or PNG format for icons
- Optimize image file sizes before adding
- Asset paths in code: `assets/icons/filename.png` or `assets/images/filename.png`

### Common Patterns
- Flutter accesses assets via `Image.asset('assets/images/...')`
- Icon assets can be used with `AssetImage`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
