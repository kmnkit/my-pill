<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Medication Screen Widgets

## Purpose
Feature-specific widgets for medication management including visual pill selectors, photo picker, inventory editor, and history display.

## Key Files

| File | Description |
|------|-------------|
| `pill_shape_selector.dart` | `PillShapeSelector` — grid of pill shape options (round, capsule, oval, etc.) |
| `pill_color_picker.dart` | `PillColorPicker` — color selection grid for medication identification |
| `photo_picker_button.dart` | `PhotoPickerButton` — camera/gallery photo selection for medication |
| `schedule_type_selector.dart` | `ScheduleTypeSelector` — daily/specific days/interval selection |
| `inventory_editor.dart` | `InventoryEditor` — total count, remaining, low stock threshold inputs |
| `history_list_item.dart` | `HistoryListItem` — individual adherence history entry display |
| `adherence_badge.dart` | `AdherenceBadge` — color-coded adherence percentage badge |

## For AI Agents

### Working In This Directory
- Pill shape/color selectors use enums from `data/enums/` for options
- Photo picker uses `image_picker` package
- Inventory editor validates numeric inputs (non-negative)
- History items show status with timestamp and color coding

## Dependencies

### Internal
- `data/enums/` — PillShape, PillColor, ScheduleType, DosageUnit
- `presentation/shared/widgets/` — MpCard, MpButton
- `core/constants/` — AppColors, AppSpacing

### External
- `image_picker` — Photo selection

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
