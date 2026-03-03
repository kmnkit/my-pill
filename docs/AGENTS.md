<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-02-02 | Updated: 2026-03-01 -->

# docs — Project Documentation

## Purpose
Comprehensive project documentation covering product requirements, deployment guides, QA reports, marketing strategy, security audits, and design decisions.

## Key Files

| File | Description |
|------|-------------|
| `product_requirements_document.md` | English PRD — full product spec, features, technical stack |
| `product_requirements_document_ja.md` | Japanese PRD — same structure, Japanese language |
| `progress.md` | Development progress tracking |
| `feedback.md` | User feedback log |
| `APP_STORE_METADATA.md` | App Store / Play Store listing metadata |
| `APP_STORE_PREPARATION.md` | App Store submission preparation checklist |
| `APP_STORE_SCREENSHOTS.md` | Screenshot specifications and strategy |
| `iOS_APP_STORE_DEPLOYMENT_GUIDE.md` | iOS App Store deployment steps |
| `iOS_DEPLOYMENT_STATUS.md` | iOS deployment status tracking |
| `iOS_DEPLOYMENT_FINAL_STATUS.md` | iOS deployment final status |
| `UI_UX_REVIEW.md` | UI/UX review findings |
| `design_dosage_timing_redesign.md` | Dosage timing UI redesign spec |
| `qa-quality-gate-report.md` | QA quality gate report |
| `qa-quality-gate-report-20260301.md` | QA quality gate report (2026-03-01) |
| `security-audit-2026-02-23.md` | Security audit results (2026-02-23) |
| `real-device-test-checklist.md` | Physical device test checklist |
| `stakeholder-launch-assessment.md` | Stakeholder launch readiness assessment |
| `CONSUMER_PANEL_INSIGHTS.md` | Consumer panel review insights |
| `CONSUMER_PANEL_INSIGHTS_G2.md` | Consumer panel review insights (round 2) |
| `CONSUMER_PANEL_REVIEW_2026_02.md` | Consumer panel review (Feb 2026) |
| `feature-evaluation-ippoka.md` | Feature evaluation — dose consolidation (一包化) |
| `AD_CREATIVE_STRATEGY.md` | Ad creative strategy |
| `ad-campaign-market-research.md` | Ad campaign market research |
| `LINE_ADS_EXECUTION_GUIDE.md` | LINE Ads execution guide |
| `GOOGLE_ADS_EXECUTION_GUIDE.md` | Google Ads execution guide |
| `monetization-strategy-early-stage.md` | Early-stage monetization strategy |
| `ua-strategy-zero-budget.md` | User acquisition strategy (zero budget) |

## Subdirectories

| Directory | Purpose |
|-----------|---------|
| `test-scenarios/` | Test scenario documents produced by Test Scenario Writer agent (see `test-scenarios/AGENTS.md`) |
| `plans/` | Implementation plans from planning sessions |

## For AI Agents

### Working In This Directory
- PRDs (`product_requirements_document*.md`) are the source of truth for features
- Both EN and JA PRDs must stay in sync when updated
- Do not modify PRDs or security audits without explicit user approval
- QA reports and deployment guides are read-only historical records
- New plans go in `plans/`, new test scenarios go in `test-scenarios/`

## Dependencies

### Internal
- Referenced by all implementation in `lib/` and `functions/`

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
