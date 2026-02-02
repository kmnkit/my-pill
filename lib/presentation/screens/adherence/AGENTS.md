<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# adherence — Adherence Reports

## Purpose
Medication adherence tracking and visualization — overall adherence score, weekly charts, per-medication breakdown with ratings (Excellent/Good/Fair/Poor).

## Key Files

| File | Description |
|------|-------------|
| `weekly_summary_screen.dart` | Weekly adherence summary — overall score, chart visualization, medication breakdown |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `widgets/` | Adherence-specific widgets — overall score, chart, medication breakdown (see `widgets/AGENTS.md`) |

## For AI Agents

### Working In This Directory
- Consumes `adherenceProvider` for calculation data
- Rating system: Excellent (95%+), Good (80-94%), Fair (50-79%), Poor (<50%)
- Charts use `fl_chart` package for visualization
- Weekly view shows 7-day adherence trend

### Common Patterns
- `FutureProvider` for adherence calculations (computed from adherence records)
- Color-coded ratings (green=excellent, blue=good, orange=fair, red=poor)
- Chart data mapped from `AdherenceRecord` models

## Dependencies

### Internal
- `data/providers/adherence_provider.dart` — Adherence calculations
- `adherence/widgets/` — Feature-specific widgets

### External
- `fl_chart` — Chart visualization

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
