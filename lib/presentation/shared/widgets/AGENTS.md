<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-03-01 -->

# widgets — Shared Widget Library

## Purpose
Reusable UI components used across multiple screens. All widgets follow the `Kd` naming prefix convention and use design tokens from `core/constants/`.

## Key Files

| File | Description |
|------|-------------|
| `kd_button.dart` | `KdButton` — primary/secondary/text variants with optional icon |
| `kd_card.dart` | `KdCard` — rounded container with custom padding, color, border, onTap |
| `kd_text_field.dart` | `KdTextField` — styled form input |
| `kd_radio_option.dart` | `KdRadioOption` — radio button selection |
| `kd_app_bar.dart` | `KdAppBar` — custom app bar |
| `kd_bottom_nav_bar.dart` | `KdBottomNavBar` — bottom navigation (patient 4-tab / caregiver 4-tab modes) |
| `kd_alert_banner.dart` | `KdAlertBanner` — warning/info banner |
| `kd_medication_card.dart` | `KdMedicationCard` — medication list item display |
| `kd_time_picker.dart` | `KdTimePicker` — time selection widget |
| `kd_avatar.dart` | `KdAvatar` — user avatar display |
| `kd_section_header.dart` | `KdSectionHeader` — section title |
| `kd_empty_state.dart` | `KdEmptyState` — empty list placeholder |
| `kd_toggle_switch.dart` | `KdToggleSwitch` — toggle switch |
| `kd_badge.dart` | `KdBadge` — status badge |
| `kd_pill_icon.dart` | `KdPillIcon` — pill visualization (shape + color) |
| `kd_progress_bar.dart` | `KdProgressBar` — progress indicator |
| `kd_color_dot.dart` | `KdColorDot` — color indicator dot |
| `kd_error_view.dart` | `KdErrorView` — error state UI |
| `kd_loading_view.dart` | `KdLoadingView` — loading state UI |
| `kd_shimmer.dart` | `KdShimmer` / `KdShimmerBox` / `KdListShimmer` — shimmer loading effects |

## For AI Agents

### Working In This Directory
- **Naming**: All widgets MUST be prefixed with `Kd` (Kusuridoki)
- **Design tokens**: Use `AppColors`, `AppSpacing`, `AppTypography` — never hardcode values
- **Stateless preferred**: Most widgets should be stateless with callback props
- **Theme-aware**: Use `Theme.of(context)` for dynamic theming (light/dark)
- Adding a new shared widget? Create `kd_widget_name.dart` with `KdWidgetName` class

### Testing Requirements
- Widget tests should verify rendering and interaction callbacks
- Test with both light and dark themes
- Test accessibility (semantic labels, contrast)

### Common Patterns
- `KdButtonVariant` enum for button styles (primary, secondary, text)
- `KdNavMode` enum for bottom nav (patient, caregiver)
- Callback props: `onTap`, `onChanged`, `onPressed`
- Optional parameters with sensible defaults

## Dependencies

### Internal
- `core/constants/` — AppColors, AppSpacing, AppTypography
- `data/enums/` — PillShape, PillColor for KdPillIcon
- `data/models/` — Medication model for KdMedicationCard

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
