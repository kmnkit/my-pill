<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Shared Widget Library

## Purpose
Reusable UI components used across multiple screens. All widgets follow the `Mp` naming prefix convention and use design tokens from `core/constants/`.

## Key Files

| File | Description |
|------|-------------|
| `mp_button.dart` | `MpButton` — primary/secondary/text variants with optional icon |
| `mp_card.dart` | `MpCard` — rounded container with custom padding, color, border, onTap |
| `mp_text_field.dart` | `MpTextField` — styled form input |
| `mp_radio_option.dart` | `MpRadioOption` — radio button selection |
| `mp_app_bar.dart` | `MpAppBar` — custom app bar |
| `mp_bottom_nav_bar.dart` | `MpBottomNavBar` — bottom navigation (patient 4-tab / caregiver 4-tab modes) |
| `mp_alert_banner.dart` | `MpAlertBanner` — warning/info banner |
| `mp_medication_card.dart` | `MpMedicationCard` — medication list item display |
| `mp_time_picker.dart` | `MpTimePicker` — time selection widget |
| `mp_avatar.dart` | `MpAvatar` — user avatar display |
| `mp_section_header.dart` | `MpSectionHeader` — section title |
| `mp_empty_state.dart` | `MpEmptyState` — empty list placeholder |
| `mp_toggle_switch.dart` | `MpToggleSwitch` — toggle switch |
| `mp_badge.dart` | `MpBadge` — status badge |
| `mp_pill_icon.dart` | `MpPillIcon` — pill visualization (shape + color) |
| `mp_progress_bar.dart` | `MpProgressBar` — progress indicator |
| `mp_color_dot.dart` | `MpColorDot` — color indicator dot |
| `mp_error_view.dart` | `MpErrorView` — error state UI |
| `mp_loading_view.dart` | `MpLoadingView` — loading state UI |

## For AI Agents

### Working In This Directory
- **Naming**: All widgets MUST be prefixed with `Mp` (MyPill)
- **Design tokens**: Use `AppColors`, `AppSpacing`, `AppTypography` — never hardcode values
- **Stateless preferred**: Most widgets should be stateless with callback props
- **Theme-aware**: Use `Theme.of(context)` for dynamic theming (light/dark)
- Adding a new shared widget? Create `mp_widget_name.dart` with `MpWidgetName` class

### Testing Requirements
- Widget tests should verify rendering and interaction callbacks
- Test with both light and dark themes
- Test accessibility (semantic labels, contrast)

### Common Patterns
- `MpButtonVariant` enum for button styles (primary, secondary, text)
- `MpNavMode` enum for bottom nav (patient, caregiver)
- Callback props: `onTap`, `onChanged`, `onPressed`
- Optional parameters with sensible defaults

## Dependencies

### Internal
- `core/constants/` — AppColors, AppSpacing, AppTypography
- `data/enums/` — PillShape, PillColor for MpPillIcon
- `data/models/` — Medication model for MpMedicationCard

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
