# Project Progress — Kusuridoki (くすりどき)

## Current Status: Post-Remediation (PO Re-evaluation Pending)

PO initial evaluation: **4.5/10 (NO-GO)**. This document reflects the state after the 6-phase remediation plan was executed to address Critical/High issues.

---

## Phase 1: Name/Bundle ID Consistency
- ✅ Task 1.1: Docs "MyPill" → "Kusuridoki" (7 files, 39+ replacements)
- ✅ Task 1.2: l10n ARB files "MyPill" → "Kusuridoki" (app_en.arb, app_ja.arb — onboardingWelcomeTitle, onboardingRoleTitle)
- ✅ Task 1.3: Info.plist permission descriptions "MyPill" → "Kusuridoki" (4 keys)
- ✅ Task 1.4: Bundle ID docs fix — `com.gingers.mypill` → `com.ginger.mypill` (14 occurrences across 3 deployment docs)
- ✅ Task 1.5: APP_STORE_METADATA.md Korean → Japanese
- ✅ Task 1.6: iOS deployment guide path/date corrections

**Verification:** `grep -r "MyPill" docs/ lib/l10n/ ios/Runner/Info.plist` — 0 hits. `grep -r "com\.gingers" docs/` — 0 hits.

## Phase 2: pubspec.yaml Version Pinning
- ✅ Task 2.1: Resolved versions extracted from pubspec.lock
- ✅ Task 2.2: 39 `any` dependencies → `^x.y.z` (Riverpod family, Freezed family compatibility maintained)
- ✅ Task 2.3: `flutter pub get` + `build_runner build` + `flutter analyze` — all pass

**Verification:** `grep "any$" pubspec.yaml` returns only Flutter SDK entries.

## Phase 3: Privacy Policy Links
- ✅ Task 3.1: l10n strings added (privacyPolicy, termsOfService in EN/JA ARBs)
- ✅ Task 3.2: Settings screen — Privacy Policy + Terms of Service ListTile items with url_launcher
- ✅ URL constants in `lib/core/constants/` for single-source management

**Note:** URLs are placeholders. Actual hosting is out of scope (requires user action).

## Phase 4: ReminderService Interval Bug Fix
- ✅ Task 4.1: `_shouldGenerateForDate()` ScheduleType.interval — was `return true;` (generating every day)
- ✅ Fixed: epoch-based modulo calculation using `intervalHours` → `intervalDays`
- ✅ Edge cases handled: null/0 intervalHours fall back to daily generation
- ✅ Timezone-safe: uses local DateTime consistently to avoid day boundary shifts

## Phase 5: Tests
- ✅ Task 5.1: ReminderService tests — 18 tests covering:
  - `_shouldGenerateForDate()`: daily, specificDays, interval (including Phase 4 bug fix verification)
  - `generateRemindersForDate()`: inactive skip, duplicate prevention, multi-time, combining existing+new
  - `markAsTaken()`: status change, actionTime, save, adherence record, not-found error
  - `markAsSkipped()`: status change, adherence record, not-found error
- ✅ Task 5.2: SubscriptionService tests — 16 tests covering:
  - Initial state: isPremium, maxCaregivers, products null
  - maxCaregivers logic: free=1, premium=999 contract
  - statusStream: broadcast, no premature emission
  - onStatusChanged callback
  - Product ID constants
  - SubscriptionStatus model: defaults, copyWith, platform enum
- ✅ Task 5.3: StorageService tests — 2 tests (instantiation, independence)
  - CRUD methods require Hive platform init — documented as integration-test-only

**Additional fixes during Phase 5:**
- Added missing `flutter_secure_storage: ^9.2.4` to pubspec.yaml dependencies
- Added missing `integration_test: sdk: flutter` to dev_dependencies
- Made `SubscriptionService._iap` lazy to enable unit testing without platform channels
- Fixed timezone bug in interval epoch calculation (local vs UTC consistency)

**Verification:** `flutter test` — 75 tests passed, 0 failures. `flutter analyze` — 0 issues.

## Phase 6: progress.md
- ✅ This file created with honest current-state assessment

---

## Overall Test Results

| Test File | Tests | Status |
|-----------|-------|--------|
| app_theme_test.dart | 4 | ✅ All pass |
| widget_test.dart | 3 | ✅ All pass |
| medication_repository_test.dart | 14 | ✅ All pass |
| adherence_service_test.dart | 10 | ✅ All pass |
| timezone_service_test.dart | 8 | ✅ All pass |
| reminder_service_test.dart | 18 | ✅ All pass |
| subscription_service_test.dart | 16 | ✅ All pass |
| storage_service_test.dart | 2 | ✅ All pass |
| **Total** | **75** | **✅ All pass** |

---

## Known Limitations / Not Yet Verified

- ⏳ NotificationService — singleton + platform binding, requires mock infrastructure refactoring for unit tests
- ⏳ IapService — singleton + InAppPurchase platform, same limitation as above
- ⏳ Privacy Policy / Terms of Service URLs — placeholders only, actual pages not hosted
- ⏳ Xcode Team signing — requires user's Apple Developer account
- ⏳ App Store Connect registration — manual process
- ⏳ TestFlight deployment — not attempted
- ⏳ Screenshots — not captured
- ⏳ AI Drug Safety feature — PRD Low priority, deferred

---

## Consumer Panel Tracker

| Gate | Date | Panel Composition | Avg Score | Pass? | Notes |
|------|------|-------------------|-----------|-------|-------|
| G1 | - | - | - | - | Not yet conducted |
| G2 | - | - | - | - | Not yet conducted |
| G3 | - | - | - | - | Not yet conducted |
| G4 | - | - | - | - | Not yet conducted |

---

## Refinement Log

### Refinement: PO Evaluation — 4.5/10 NO-GO
- **Severity**: Major
- **Trigger**: PO evaluation identified Critical/High issues across naming, versioning, privacy, testing
- **Decision by**: Plan approved after DA review
- **Selected plan**: 6-phase remediation (name consistency, version pinning, privacy links, interval bug fix, tests, progress tracking)
- **Result**: All 6 phases completed. 75 tests passing, 0 analyze issues.
- **Re-verification**: PO re-evaluation pending
- **Cycle**: 1st

### Refinement: DA Review — Additional Issues Found
- **Severity**: Major (expanded scope of Phase 1 + added Phase 4)
- **Trigger**: Devils Advocate identified Bundle ID mismatch, l10n/Info.plist "MyPill" remnants, interval bug, platform service test limitations
- **Decision by**: Main agent + DA joint review
- **Selected plan**: Added Tasks 1.2-1.4 to Phase 1, added Phase 4 (interval bug), scoped Phase 5 to pure-Dart services only
- **Result**: All DA findings addressed
- **Cycle**: 1st
