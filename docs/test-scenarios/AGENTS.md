<!-- Parent: ../AGENTS.md -->
<!-- Generated: 2026-03-01 | Updated: 2026-03-01 -->

# test-scenarios — Test Scenario Documents

## Purpose
Persistent test scenario documents produced by the Test Scenario Writer agent. Each document defines structured test cases with SCENARIO_IDs used by the QA Engineer agent for execution.

## Key Files

| File | Description |
|------|-------------|
| `README.md` | Scenario document format and QA workflow guide |
| `caregiver-device-test-matrix.md` | Cross-device test matrix for caregiver features |
| `travel-mode-e2e.md` | End-to-end test scenarios for travel mode timezone flow |

## For AI Agents

### Working In This Directory
- Scenario documents are **persistent artifacts** — never delete after test execution
- When a production bug is found, add a regression scenario before merging the fix
- Format: `{feature}-{type}.md` (e.g., `medication-add-unit.md`, `caregiver-e2e.md`)
- Each scenario must have a unique `SCENARIO_ID` used for QA reporting

### QA Workflow
1. Test Scenario Writer (Opus) → produces scenario document here
2. QA Engineer (Sonnet) → reads scenario document, executes, reports pass/fail per ID
3. All critical + high scenarios must pass before release

<!-- MANUAL: Any manually added notes below this line are preserved on regeneration -->
