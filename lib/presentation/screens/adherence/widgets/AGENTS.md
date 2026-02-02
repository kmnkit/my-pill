<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-02-02 -->

# widgets — Adherence Screen Widgets

## Purpose
Feature-specific widgets for adherence reporting including overall score display, weekly chart visualization, and per-medication breakdown.

## Key Files

| File | Description |
|------|-------------|
| `overall_score.dart` | `OverallScore` — large circular percentage display with rating label |
| `adherence_chart.dart` | `AdherenceChart` — 7-day bar/line chart of adherence trend |
| `medication_breakdown.dart` | `MedicationBreakdown` — per-medication adherence list with individual ratings |

## For AI Agents

### Working In This Directory
- Overall score uses color coding: green (95%+), blue (80-94%), orange (50-79%), red (<50%)
- Chart uses `fl_chart` package — configure via `BarChartData` or `LineChartData`
- Breakdown shows each medication with its own adherence percentage and rating

## Dependencies

### Internal
- `data/providers/adherence_provider.dart` — Calculation data
- `core/constants/` — AppColors for rating colors

### External
- `fl_chart` — Chart rendering

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
