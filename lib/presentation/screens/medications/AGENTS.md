<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# medications — Medication Management

## Purpose
Complete medication CRUD interface — list all medications, add new medications with dosage/shape/color/photo, view medication details with history and adherence, and edit existing medications.

## Key Files

| File | Description |
|------|-------------|
| `medications_list_screen.dart` | Medication list with search, low stock indicators, and add button |
| `add_medication_screen.dart` | Multi-step form — name, dosage, shape, color, photo, inventory |
| `medication_detail_screen.dart` | Detail view — medication info, adherence badge, history list, edit/delete actions |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Medication-specific widgets — pill shape/color selectors, photo picker, inventory editor, etc. (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Add medication flow: form → validate → `ref.read(medicationListProvider.notifier).addMedication()`
- Detail screen receives medication ID via route parameter (`:id`)
- Delete operation triggers cascade delete (medication + schedules + reminders + adherence)
- Inventory editing updates remaining count and low stock threshold

### Common Patterns
- Form validation before submission
- `GoRouter` path parameters for medication ID
- `ref.watch()` for reactive UI updates after mutations

## Dependencies

### Internal
- `data/providers/medication_provider.dart` — CRUD operations
- `data/providers/adherence_provider.dart` — Adherence display
- `data/models/medication.dart` — Data type
- `data/enums/` — PillShape, PillColor, DosageUnit
- `medications/widgets/` — Feature-specific widgets

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
