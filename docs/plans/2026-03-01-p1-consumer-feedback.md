# P1 Consumer Feedback Fixes Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Fix 3 P1 issues from G4 consumer panel to push recommendation intent from 6.2 to ≥ 6.5/10.

**Architecture:**
- Task 1 (P1-2): One-line duration change in `medication_timeline.dart` — no new files.
- Task 2 (P1-3): Add "Share guide" button in `_CaregiverConnectGuide`; uses `share_plus` (already in pubspec).
- Task 3 (P1-1): New `WeeklyAdherenceSummaryCard` widget; reads existing `overallAdherenceProvider`; inserted into `HomeScreen` above the timeline.

**Tech Stack:** Flutter 3.41+, Riverpod v3, share_plus ^12.0.1, flutter gen-l10n

---

## Task 1 — Snackbar Duration 2s → 4s (P1-2)

**Files:**
- Modify: `lib/presentation/screens/home/widgets/medication_timeline.dart`

**Step 1: Change all 3 `Duration(seconds: 2)` in the snackbar block to `Duration(seconds: 4)`**

Located at the three SnackBar calls (take / skip / snooze) in the `onMarkTaken` callback. There are exactly 3 occurrences inside the ReminderAction switch inside `medication_timeline.dart`.

**Step 2: Verify no existing test checks snackbar duration**

Run: `flutter test test/presentation/screens/home/ -v`
Expected: All PASS (no test asserts duration).

**Step 3: Commit**

```
git add lib/presentation/screens/home/widgets/medication_timeline.dart
git commit -m "fix: increase snackbar duration to 4s for elderly readability"
```

---

## Task 2 — Caregiver QR Guide "Share this guide" Button (P1-3)

**Files:**
- Modify: `lib/l10n/app_en.arb` — add `shareConnectGuide` key
- Modify: `lib/l10n/app_ja.arb` — add `shareConnectGuide` key
- Regenerate: run `flutter gen-l10n`
- Modify: `lib/presentation/screens/caregivers/caregiver_dashboard_screen.dart` — add `OutlinedButton.icon` in `_CaregiverConnectGuide`
- Modify: `test/presentation/screens/caregivers/caregiver_dashboard_screen_test.dart` — add test

**Step 1: Add l10n key**

Add to `app_en.arb`:
- Key: `shareConnectGuide`, Value: `"Share this guide"`

Add to `app_ja.arb`:
- Key: `shareConnectGuide`, Value: `"この手順を共有する"`

**Step 2: Regenerate l10n**

Run: `flutter gen-l10n`
Expected: `app_localizations_en.dart` and `app_localizations_ja.dart` updated.

**Step 3: Write a failing test for the share button**

In `test/presentation/screens/caregivers/caregiver_dashboard_screen_test.dart`, add a test:
- Title: `'shows share guide button in connect guide'`
- Setup: same overrides as existing empty-state tests (`caregiverPatientsProvider` → empty list, `canAddPatientProvider` → true)
- Assert: `find.byIcon(Icons.share)` findsOneWidget

Run: `flutter test test/presentation/screens/caregivers/caregiver_dashboard_screen_test.dart -v`
Expected: FAIL — `Icons.share` not found (0 widgets).

**Step 4: Implement — add share button to `_CaregiverConnectGuide`**

In `lib/presentation/screens/caregivers/caregiver_dashboard_screen.dart`:

- Add import: `package:share_plus/share_plus.dart`
- In `_CaregiverConnectGuide.build()`, after the existing `ElevatedButton.icon` (QR scan), add an `OutlinedButton.icon` with:
  - icon: `Icons.share`
  - label: `l10n.shareConnectGuide`
  - onPressed: call `SharePlus.instance.share(ShareParams(text: shareText))` where `shareText` is a multi-line string combining `l10n.connectStep1`, `l10n.connectStep2`, `l10n.connectStep3` (one per line, numbered).
- The button should be inside the same `Column` as the QR button, separated by `SizedBox(height: AppSpacing.sm)`.

**Step 5: Run the test to verify it passes**

Run: `flutter test test/presentation/screens/caregivers/caregiver_dashboard_screen_test.dart -v`
Expected: All PASS.

**Step 6: Run full test suite**

Run: `flutter test`
Expected: All PASS.

**Step 7: Commit**

```
git add lib/l10n/app_en.arb lib/l10n/app_ja.arb \
        lib/l10n/app_localizations*.dart \
        lib/presentation/screens/caregivers/caregiver_dashboard_screen.dart \
        test/presentation/screens/caregivers/caregiver_dashboard_screen_test.dart
git commit -m "feat: add share guide button in caregiver connect guide"
```

---

## Task 3 — Weekly Adherence Summary Card on Home Screen (P1-1)

**Files:**
- Create: `lib/presentation/screens/home/widgets/weekly_adherence_summary_card.dart`
- Modify: `lib/presentation/screens/home/home_screen.dart`
- Create: `test/presentation/screens/home/widgets/weekly_adherence_summary_card_test.dart`

**Step 1: Write a failing widget test**

Create `test/presentation/screens/home/widgets/weekly_adherence_summary_card_test.dart`.

Test cases (use `createTestableWidget` from `test/helpers/widget_test_helpers.dart`):

- `'shows percentage when overallAdherence returns data'`
  - Override `overallAdherenceProvider` → `Future.value(0.85)` (85%)
  - Assert: `find.textContaining('85')` findsOneWidget, `find.byIcon(Icons.bar_chart)` findsOneWidget

- `'shows empty state when overallAdherence returns null'`
  - Override `overallAdherenceProvider` → `Future.value(null)`
  - Assert: `find.byType(WeeklyAdherenceSummaryCard)` findsOneWidget (no crash)

Run: `flutter test test/presentation/screens/home/widgets/weekly_adherence_summary_card_test.dart -v`
Expected: FAIL — `WeeklyAdherenceSummaryCard` not found.

**Step 2: Create the widget**

Create `lib/presentation/screens/home/widgets/weekly_adherence_summary_card.dart`:

- Class: `WeeklyAdherenceSummaryCard extends ConsumerWidget`
- Watches: `overallAdherenceProvider` (returns `AsyncValue<double?>`, 0.0–1.0 range)
- Layout (Card with rounded corners):
  - Leading: `Icons.bar_chart` icon (AppColors.primary)
  - Title: `l10n.thisWeek` (already exists in l10n)
  - Trailing: `l10n.adherenceRatePercent(percent)` where `percent` is `(value * 100).round().toString()` — or `l10n.startTrackingMessage` condensed if null
  - Loading state: `KdShimmerBox(height: 56)` (already used in codebase)
  - Error state: `SizedBox.shrink()`
- When `data` is null (no records yet): show `l10n.startTrackingMessage` truncated or a short dash `–`

**Step 3: Run the widget tests to verify PASS**

Run: `flutter test test/presentation/screens/home/widgets/weekly_adherence_summary_card_test.dart -v`
Expected: All PASS.

**Step 4: Insert widget into HomeScreen**

In `lib/presentation/screens/home/home_screen.dart`, insert `const WeeklyAdherenceSummaryCard()` between `GreetingHeader` and `MedicationTimeline` (with `SizedBox(height: AppSpacing.lg)` spacing on each side).

Pattern (current):
```
GreetingHeader → SizedBox(xxl) → MedicationTimeline
```
After:
```
GreetingHeader → SizedBox(lg) → WeeklyAdherenceSummaryCard → SizedBox(lg) → MedicationTimeline
```

**Step 5: Verify HomeScreen tests still pass**

Run: `flutter test test/presentation/screens/home/ -v`
Expected: All PASS. The `home_screen_test.dart` uses `overallAdherenceProvider` which is not currently overridden — add it to `_baseOverrides()` in the test: `overallAdherenceProvider.overrideWith((ref) => Future.value(null))` to keep tests isolated.

**Step 6: Run full test suite**

Run: `flutter test`
Expected: All PASS.

**Step 7: Run analyze**

Run: `flutter analyze`
Expected: 0 errors on changed files.

**Step 8: Commit**

```
git add lib/presentation/screens/home/widgets/weekly_adherence_summary_card.dart \
        lib/presentation/screens/home/home_screen.dart \
        test/presentation/screens/home/widgets/weekly_adherence_summary_card_test.dart
git commit -m "feat: add weekly adherence summary card to home screen"
```

---

## Final Verification

Run: `flutter test && flutter analyze`
Expected: All tests PASS, 0 errors.

### Devil's Advocate Review
- **도전한 가정**: `overallAdherence` provider가 "이번 주" 데이터만 반환한다고 가정 — 실제로는 전체 기간 평균. G4 패널에서 "이번 주 복약률"이 핵심 요구였음. 그러나 주간 분리 집계를 위해 `weeklyAdherence` provider(Map<day, %> 반환)를 사용하면 복잡도가 크게 증가하므로, 카드 레이블을 `l10n.thisWeek`이 아닌 `l10n.adherenceRate`(전체 복약률)로 표시하거나 `overallAdherence`를 사용하되 "전체 복약률" 라벨로 정직하게 표시하는 것이 더 정확함.
- **검토한 대안**: `weeklyAdherence` provider 사용 → 7개 값 평균 계산 필요, 로직 추가 — YAGNI 위반 가능. `overallAdherence` 사용 + 정확한 레이블이 더 단순하고 정직함.
- **결론**: `overallAdherence` 사용, 레이블은 `l10n.adherenceRate` 사용 (전체 복약률). `l10n.thisWeek`은 사용하지 않음.
