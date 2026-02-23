# QA Quality Gate Report - Kusuridoki (くすりどき)
## Date: 2026-02-24
## Based on: 530 Test Scenarios (test-scenario-writer output)

---

## Summary

| Test Type | Status | Details |
|-----------|--------|---------|
| Static Analysis | **PASS** | 0 issues (`flutter analyze` clean) |
| Unit Tests | **PASS** | 95/95 passed, 0 failures |
| Test Coverage | **FAIL** | 14.9% (target: 80%) |
| Build Check | **PASS** | Code gen + build clean |
| Regression | **PASS** | 0 new failures |
| Bug Verification | **FAIL** | 18/20 bugs CONFIRMED |
| Usability Audit | **CONDITIONAL** | 45 issues (13 High, 21 Medium, 11 Low) |
| Security Audit | **FAIL** | 18 issues (2 Critical, 5 High, 6 Medium, 5 Low) |

### Overall Verdict: FAIL

Release is blocked until CRITICAL and HIGH issues are resolved.

---

## Bug Verification Results

### Verified Bugs (18 CONFIRMED)

| BUG_ID | STATUS | SEVERITY | FILE:LINE | SUMMARY |
|--------|--------|----------|-----------|---------|
| BUG-01 | **CONFIRMED** | CRITICAL | `medication_provider.dart:28-31` | deleteMedication bypasses repository cascade — orphaned reminders/schedules/photos |
| BUG-02 | **CONFIRMED** | CRITICAL | `day_selector.dart:29-40` + `reminder_service.dart:65-66` | 0-indexed days vs DateTime.weekday 1-7 — ALL specificDays schedules off by one |
| BUG-03 | **CONFIRMED** | CRITICAL | `adherence_service.dart:126-130` vs `overall_score.dart:18-21` | Service thresholds 95/80/50 vs UI 90/75/60 — same % different ratings |
| BUG-04 | **CONFIRMED** | HIGH | `premium_gate.dart:91, :247` | `context.push(RouteNames.premium)` pushes relative name, not path `/premium` |
| BUG-05 | **CONFIRMED** | HIGH | `edit_medication_screen.dart:337-343` | Missing `dosageValue <= 0` validation (exists in Add screen) |
| BUG-06 | **CONFIRMED** | HIGH | `schedule_screen.dart:122-154` | Interval schedule has no TimeSlotPicker — `_times` always empty, save always fails |
| BUG-07 | **CONFIRMED** | HIGH | `notification_settings.dart:16-18` | Push/critical/snooze use local setState only — not persisted |
| BUG-08 | **CONFIRMED** | HIGH | `data_sharing_dialog.dart:22-24` | All toggles local setState — no persistence |
| BUG-09 | **CONFIRMED** | HIGH | `caregiver_settings_screen.dart:29-30` | missedDose/lowStock alerts local setState only |
| BUG-10 | **CONFIRMED** | HIGH | `mp_confirm_dialog.dart:58` | `isDestructive ? primary : primary` — both branches identical |
| BUG-11 | **CONFIRMED** | HIGH | `mp_confirm_dialog.dart:11-12, 25-26` | Default "Confirm"/"Cancel" hardcoded English |
| BUG-12 | **CONFIRMED** | MEDIUM | `low_stock_banner.dart:33-35` | onTap callback body empty — no navigation |
| BUG-14 | **CONFIRMED** | MEDIUM | `export_report_button.dart:71` (not report_service) | `const userName = 'User'` hardcoded |
| BUG-15 | **CONFIRMED** | MEDIUM | `error_handler.dart:19-31` | All 5 error messages hardcoded English |
| BUG-16 | **CONFIRMED** | MEDIUM | `mp_time_picker.dart:25, 63` | AM/PM literal strings, no l10n |
| BUG-17 | **CONFIRMED** | MEDIUM | `home_widget_service.dart:64` | `'$taken/$total taken'` English-only |
| BUG-18 | **CONFIRMED** | MEDIUM | `backup_sync_dialog.dart:32` | `Future.delayed(2s)` — no real sync |
| BUG-20 | **CONFIRMED** | LOW | `mp_progress_bar.dart:30-31`, `mp_pill_icon.dart:32-34` | Semantics labels English-only |

### Denied Bugs (2)

| BUG_ID | STATUS | REASON |
|--------|--------|--------|
| BUG-13 | **DENIED** | `AdherenceService` correctly returns `null` when total=0. Bug migrated to `report_service.dart:27,70,229,262` where `'100.0'` is used as fallback — filed as NEW BUG-21 |
| BUG-19 | **DENIED** | Deactivate vs Delete are intentionally separate flows. Deactivate = sign out + clear local. Delete = full server erasure with `CloudFunctionsService().deleteAccount()`. However, Security Audit flagged H-2: deactivate leaves server data (privacy concern). |

### New Bugs Discovered During QA

| NEW_ID | SEVERITY | FILE:LINE | SUMMARY |
|--------|----------|-----------|---------|
| BUG-21 | MEDIUM | `report_service.dart:27,70,229,262` | PDF reports show "100.0%" when no data (should show "N/A") |
| SEC-C1 | **CRITICAL** | `firebase_options.dart:53,61` | Live Firebase API keys on disk — verify git history, rotate if ever committed |
| SEC-C2 | **CRITICAL** | `firestore_service.dart:13-15` | Null `_userId` writes medical data to `users/null` document — no guard |
| SEC-H1 | **HIGH** | `functions/index.js:231-248` | `verifyReceipt` grants premium WITHOUT calling Apple/Google verification APIs |
| SEC-H2 | **HIGH** | `caregiver_settings_screen.dart:142-159` | Deactivate leaves caregiverAccess docs on server — patient privacy violation |
| SEC-H3 | **HIGH** | `app_router_provider.dart:92-95` | `/invite/:code` route bypasses auth guard — unauthenticated access to invite screen |
| SEC-H4 | **HIGH** | `notification_service.dart:113-115` | FCM token logged via debugPrint in debug builds |
| SEC-H5 | **HIGH** | `caregiver_monitoring_provider.dart:19-29` | No client-side patient authorization check — relies solely on Firestore rules |
| SEC-M6 | MEDIUM | `notification_service.dart:161,258` | Notification ID via `hashCode` — collision risk silences medication reminders |

---

## Security Audit Highlights

### Overall Security Posture: NEEDS_IMPROVEMENT

**Strengths (done well):**
- Hive AES-256 encryption at rest with Keychain/Keystore key management
- Photo encryption with same AES-256 scheme
- Re-authentication required before account deletion
- Firestore rules architecture correct (user-scoped, Cloud Functions-only writes for sensitive collections)
- Rate limiting on all Cloud Functions (5 calls/min)
- Self-invitation prevention in acceptInvite
- Deep link validation with strict host whitelist + regex
- No HTTP URLs — all HTTPS
- No hardcoded secrets in application code (firebase_options.dart is gitignored)
- `mounted` checks consistent after async gaps

**Must fix before release:**
1. **SEC-C2**: Null userId guard in FirestoreService (medical data written to `users/null`)
2. **SEC-H1**: Real IAP receipt verification in Cloud Functions
3. **SEC-C1**: Verify firebase_options.dart was never git-committed; rotate keys if it was

---

## Usability Audit Highlights

### 45 Issues Found

| Category | High | Medium | Low | Total |
|----------|------|--------|-----|-------|
| Accessibility | 3 | 5 | 3 | 11 |
| Loading/Error/Empty States | 2 | 4 | 2 | 8 |
| Localization Gaps | 5 | 7 | 3 | 15 |
| Layout/Overflow Risks | 1 | 3 | 2 | 6 |
| Navigation | 2 | 2 | 1 | 5 |
| **Total** | **13** | **21** | **11** | **45** |

**Top 5 Usability Issues:**
1. Premium navigation broken (BUG-04 duplicate)
2. 5 HIGH localization gaps — JP users see English in: dialogs, errors, time picker, day selector, stock badge
3. Color picker, day selector, snooze chips have zero Semantics — screen readers cannot use them
4. Raw `error.toString()` exposed in edit medication and caregiver dashboard
5. LowStockBanner dead tap (BUG-12 duplicate)

---

## Test Coverage

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Line Coverage | 14.9% | 80% | **FAIL** |
| Tests Passing | 95/95 | 100% | PASS |
| Test Files | 13 | — | — |

### Coverage Gap Root Cause

The entire `presentation/` layer (screens, widgets, dialogs, router) has **zero widget tests**. All 95 tests are pure-Dart service/utility tests. To reach 80%, approximately 400+ widget and provider tests need to be written.

### Critical Untested Paths

| Path | Risk |
|------|------|
| All Riverpod providers | State management untested |
| All screens (home, medications, schedule, adherence, settings, caregivers) | UI behavior untested |
| All shared widgets (Mp-prefixed) | Component behavior untested |
| GoRouter navigation + auth guards | Route protection untested |
| storage_service.dart (191 lines, 0% coverage) | Data persistence untested |

---

## Priority Fix Order

### Phase 1: CRITICAL (Must fix before ANY release)

| # | Issue | Type | Impact |
|---|-------|------|--------|
| 1 | BUG-01: Cascade delete missing | Data Integrity | Orphaned data on every medication deletion |
| 2 | BUG-02: DaySelector index mismatch | Core Feature | ALL specificDays schedules broken |
| 3 | BUG-03: Rating threshold mismatch | UX Consistency | Contradictory ratings shown to users |
| 4 | SEC-C2: Null userId in Firestore writes | Security | Medical data written to shared `users/null` |
| 5 | SEC-H1: IAP receipt not verified | Security/Revenue | Complete premium bypass |

### Phase 2: HIGH (Must fix before release)

| # | Issue | Type |
|---|-------|------|
| 6 | BUG-04: PremiumGate navigation broken | Navigation |
| 7 | BUG-05: Edit dosage validation missing | Validation |
| 8 | BUG-06: Interval schedule unusable | Core Feature |
| 9 | BUG-07~09: Settings not persisted (3 bugs) | Persistence |
| 10 | BUG-10: isDestructive no visual effect | UX Safety |
| 11 | BUG-11: Dialog labels English-only | Localization |
| 12 | SEC-H2: Deactivate leaves server data | Privacy |
| 13 | SEC-H3: Invite route bypasses auth | Security |
| 14 | SEC-C1: Verify firebase_options git history | Security |

### Phase 3: MEDIUM (Fix before production)

| # | Issues |
|---|--------|
| 15 | BUG-12, 14, 15, 16, 17, 18, 21 (l10n, dead tap, simulated sync) |
| 16 | SEC-M1~M6 (nullable reads, IAP flow, PDF temp, notification ID collision) |
| 17 | Usability Medium issues (21 items) |

### Phase 4: LOW (Next iteration)

| # | Issues |
|---|--------|
| 18 | BUG-20 (accessibility labels) |
| 19 | Usability Low issues (11 items) |
| 20 | Security informational (5 items) |

---

## Recommendations

1. **Immediate**: Fix the 5 CRITICAL items before any further testing or release preparation
2. **Short-term**: Write widget tests for all screens — current 14.9% coverage is far below the 80% target
3. **Medium-term**: Add integration tests for Firestore dual storage sync, provider chains, and navigation flows
4. **Process**: Every new feature must have corresponding widget tests before merge (enforce via CI coverage gate)

---

## Appendix: Full Report Locations

| Report | Location |
|--------|----------|
| Test Scenarios (530) | `docs/test-scenarios/README.md` |
| Security Audit Detail | `docs/security-audit-2026-02-23.md` |
| This QA Report | `docs/qa-quality-gate-report.md` |

---

**QA Engineer Verdict: FAIL — 5 CRITICAL blockers must be resolved before release.**
