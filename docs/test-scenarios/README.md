# Test Scenario Document - Kusuridoki Full App
## Generated: 2026-02-23
## Total Scenarios: 530 | Critical: 135 | High: 243 | Medium: 128 | Low: 24

---

## Module Breakdown

| Module | Scenarios | Critical | High | Medium | Low | Bugs Found |
|--------|-----------|----------|------|--------|-----|------------|
| Auth & Onboarding | 57 | 18 | 27 | 10 | 2 | 0 |
| Medication CRUD | 65 | 18 | 31 | 14 | 2 | 2 |
| Schedule & Reminders | 114 | 18 | 65 | 25 | 6 | 2 |
| Adherence & Reports | 84 | 28 | 36 | 17 | 3 | 1 |
| Caregiver & Settings | 97 | 25 | 42 | 24 | 6 | 5 |
| Navigation & Shared | 113 | 28 | 42 | 38 | 5 | 10 |

---

## Critical Bug Candidates (Must Fix Before Release)

### BUG-01: Provider Cascade Delete Missing (CRITICAL)
- **File:** `lib/data/providers/medication_provider.dart`
- **Issue:** `MedicationList.deleteMedication` calls `storage.deleteMedication(id)` directly, bypassing `MedicationRepository.deleteMedication` which handles cascade deletion of reminders, adherence records, schedules, and photo files.
- **Impact:** Orphaned data in storage after medication deletion.
- **Scenario:** MED-PROV-007

### BUG-02: DaySelector Weekday Index Mismatch (CRITICAL CONFIRMED)
- **File:** `lib/presentation/screens/schedule/widgets/day_selector.dart`
- **Issue:** `DaySelector` widget emits 0-indexed days (0-6) but `_isScheduledDay` checks `DateTime.weekday` (1-7). ALL specificDays schedules are off by one day.
- **Impact:** Users selecting Monday get Sunday's schedule.
- **Scenario:** BUG-001

### BUG-03: Adherence Rating Threshold Mismatch (CRITICAL)
- **File:** `lib/data/services/adherence_service.dart` vs `lib/presentation/screens/adherence/widgets/overall_score.dart`
- **Issue:** `AdherenceService.getAdherenceRating()` uses thresholds 95/80/50 while `OverallScore._rating()` uses 90/75/60. Same percentage gets different ratings.
- **Impact:** Inconsistent user experience between service and UI.
- **Scenario:** SVC-REGRESSION-001

### BUG-04: PremiumGate Route Name vs Path (HIGH)
- **File:** `lib/presentation/shared/widgets/premium_gate.dart:91`
- **Issue:** `context.push(RouteNames.premium)` pushes route name 'premium' not path '/premium'.
- **Impact:** Premium upsell navigation may fail.
- **Scenario:** WIDGET-PREM-003

### BUG-05: Edit Screen Missing Dosage Validation (HIGH)
- **File:** `lib/presentation/screens/medications/medication_edit_screen.dart`
- **Issue:** Edit medication screen lacks `dosageValue <= 0` validation that exists in Add screen.
- **Impact:** Users can save medications with zero or negative dosage.
- **Scenario:** MED-UI-EDIT-005

### BUG-06: Interval Schedule Cannot Be Saved (HIGH)
- **File:** `lib/presentation/screens/schedule/schedule_screen.dart`
- **Issue:** No `TimeSlotPicker` is rendered for interval type, leaving `_times` empty, which fails validation.
- **Impact:** Interval schedules are completely unusable.
- **Scenario:** RISK-003

### BUG-07: Notification Settings Not Persisted (HIGH)
- **File:** `lib/presentation/screens/settings/widgets/notification_settings.dart`
- **Issue:** Push notifications, critical alerts, and snooze duration use local `setState` only. NOT persisted via `userSettingsProvider`.
- **Impact:** Settings reset on navigation.
- **Scenario:** SETTINGS-EDGE-001

### BUG-08: Data Sharing Preferences Not Persisted (HIGH)
- **File:** `lib/presentation/screens/settings/widgets/data_sharing_dialog.dart`
- **Issue:** Toggle states use local `setState` only, no persistence mechanism.
- **Impact:** Preferences lost on dialog close.
- **Scenario:** SETTINGS-EDGE-002

### BUG-09: Caregiver Alert Toggles Not Persisted (HIGH)
- **File:** `lib/presentation/screens/caregivers/caregiver_settings_screen.dart`
- **Issue:** missedDoseAlerts, lowStockAlerts use local `setState` only.
- **Impact:** Alert preferences reset on navigation.
- **Scenario:** CGSETTINGS-EDGE-003

### BUG-10: MpConfirmDialog isDestructive No Visual Effect (HIGH)
- **File:** `lib/presentation/shared/dialogs/mp_confirm_dialog.dart:58`
- **Issue:** `isDestructive` ternary always returns same value (no visual difference).
- **Impact:** Destructive actions look identical to normal confirmations.
- **Scenario:** DLG-CONFIRM-004

### BUG-11: MpConfirmDialog Default Labels Not Localized (HIGH)
- **File:** `lib/presentation/shared/dialogs/mp_confirm_dialog.dart:14-15`
- **Issue:** Default button labels hardcoded in English ("Confirm"/"Cancel").
- **Impact:** Japanese users see English button text.
- **Scenario:** DLG-CONFIRM-003

### BUG-12: LowStockBanner onTap Empty (MEDIUM)
- **File:** `lib/presentation/screens/home/widgets/low_stock_banner.dart:33`
- **Issue:** onTap callback is empty, no navigation occurs.
- **Impact:** Low stock banner is not actionable.
- **Scenario:** HOME-STOCK-004

### BUG-13: Misleading 100% on No Data (MEDIUM)
- **File:** `lib/data/services/adherence_service.dart`
- **Issue:** Reports show "100.0%" when total taken+missed=0.
- **Impact:** Misleading adherence rate for new users.
- **Scenario:** SVC-REGRESSION-002

### BUG-14: Hardcoded userName in Export (MEDIUM)
- **File:** `lib/data/services/report_service.dart`
- **Issue:** Export uses `const userName = 'User'` instead of actual user name.
- **Impact:** All PDF reports show "User" instead of the person's name.
- **Scenario:** SVC-REGRESSION-003

### BUG-15: ErrorHandler English-Only (MEDIUM)
- **File:** `lib/core/utils/error_handler.dart`
- **Issue:** All error messages are hardcoded English, not localized.
- **Impact:** Japanese users see English error messages.
- **Scenario:** ERR-004

### BUG-16: MpTimePicker AM/PM Hardcoded English (MEDIUM)
- **File:** `lib/presentation/shared/widgets/mp_time_picker.dart:25`
- **Issue:** AM/PM labels not localized.
- **Scenario:** WIDGET-TP-007

### BUG-17: HomeWidgetService Summary English-Only (MEDIUM)
- **File:** `lib/data/services/home_widget_service.dart:64`
- **Issue:** summary_text saves '3/5 taken' (English) regardless of locale.
- **Scenario:** HW-005

### BUG-18: BackupSyncDialog Simulated Sync (MEDIUM)
- **File:** `lib/presentation/screens/settings/widgets/backup_sync_dialog.dart`
- **Issue:** Sync operation is `Future.delayed(2 seconds)` - no actual sync implementation.
- **Scenario:** SETTINGS-EDGE-003

### BUG-19: CaregiverSettings Deactivate Missing Server Delete (MEDIUM)
- **File:** `lib/presentation/screens/caregivers/caregiver_settings_screen.dart`
- **Issue:** Calls `signOut()` but NOT `CloudFunctionsService().deleteAccount()` - data remains on server.
- **Scenario:** CGSETTINGS-EDGE-005

### BUG-20: Accessibility Labels English-Only (LOW)
- **Files:** `mp_progress_bar.dart`, `mp_pill_icon.dart`
- **Issue:** Semantics labels hardcoded in English.
- **Scenarios:** L10N-GAP-005, L10N-GAP-006

---

## Coverage Gap Summary

### Untested Areas
1. **Firebase Firestore sync** - No integration test for dual storage synchronization
2. **Push notification delivery** - End-to-end notification flow untested
3. **IAP receipt validation** - Server-side verification not testable in unit tests
4. **Deep link handling** - Platform-specific URI handling
5. **Home widget rendering** - Native widget rendering not testable in Flutter tests
6. **Camera/QR scanning** - Hardware-dependent features
7. **PDF generation output** - Visual verification of generated PDFs

### Insufficiently Tested Areas
1. **Timezone calculations** - DST transitions, half-hour offsets (India, Nepal)
2. **Concurrent operations** - Multiple rapid take/snooze actions
3. **Data migration** - Schema version upgrades
4. **Offline/online transitions** - Network state changes during operations
5. **Memory pressure** - Large medication lists (100+)

---

## Scenario Documents (Full Details)

Each module's complete scenarios are in the agent output files:
- Auth & Onboarding: Agent 1 output
- Medication CRUD: Agent 2 output
- Schedule & Reminders: Agent 3 output
- Adherence & Reports: Agent 4 output
- Caregiver & Settings: Agent 5 output (`/private/tmp/claude-501/-Users-gingermarco-develop-flutter-kusuridoki/tasks/ac3c8588fbf18f957.output`)
- Navigation & Shared: Agent 6 output (`/private/tmp/claude-501/-Users-gingermarco-develop-flutter-kusuridoki/tasks/a67a7c1da0afc012b.output`)

---

## Execution Order Recommendation

### Phase 1: Critical Blockers (Must Fix First)
Fix BUG-01 through BUG-03 before any testing — these affect core functionality.

### Phase 2: Critical Scenarios (135 scenarios)
Run all critical-priority scenarios across all 6 modules.

### Phase 3: High Priority (243 scenarios)
Run high-priority scenarios, focusing on:
- Business logic correctness
- Data persistence integrity
- Navigation flows
- Error handling

### Phase 4: Medium Priority (128 scenarios)
Edge cases, l10n gaps, accessibility checks.

### Phase 5: Low Priority (24 scenarios)
Cosmetic, minor edge cases.

---

HANDOFF -> QA Engineer: 530 scenarios ready. Coverage gaps identified: 12. Critical priority items: 135. Bug candidates: 20.
