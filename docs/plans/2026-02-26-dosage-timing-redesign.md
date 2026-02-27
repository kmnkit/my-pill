# Dosage Timing Redesign Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Replace the disconnected `timesPerDay` / `times` / `dosageTimings` fields in Schedule with a unified `dosageSlots` (List\<DosageTimeSlot\>) where each DosageTiming preset drives a time slot with hard range limits.

**Architecture:** DosageTiming enum gets time metadata (defaults + ranges). New DosageTimeSlot Freezed model pairs a DosageTiming with a user-adjustable time. Schedule model replaces 3 fields with `dosageSlots`. UI flow becomes: Frequency -> Timing Selection -> Range-limited Time Adjustment.

**Tech Stack:** Flutter, Dart, Freezed v3, Riverpod v3 (codegen), GoRouter

**Design Doc:** `docs/design_dosage_timing_redesign.md`

---

## Phase 1: DosageTiming Enum Enhancement

### Task 1.1: Write tests for DosageTiming time metadata

**Files:**
- Create: `test/data/enums/dosage_timing_test.dart`

**What to test:**
- Each preset has correct default time (morning=08:00, noon=12:00, evening=18:00, bedtime=22:00)
- Each preset has correct range (morning=05-10, noon=11-14, evening=15-20, bedtime=21-01)
- `defaultTimeOfDay` getter returns correct `TimeOfDay`
- `isTimeInRange(hour, minute)` returns true for in-range, false for out-of-range
- Bedtime wrap-around: 23:00 in range, 02:00 out of range, 01:59 in range, 00:30 in range

**Run:** `flutter test test/data/enums/dosage_timing_test.dart`
**Expected:** FAIL (methods not yet implemented)

**Commit:** `test: add DosageTiming time metadata tests`

---

### Task 1.2: Implement DosageTiming time metadata

**Files:**
- Modify: `lib/data/enums/dosage_timing.dart`

**Changes:**
- Add fields to enum constructor:

| Field | Type | Description |
|-------|------|-------------|
| defaultHour | int | Default hour |
| defaultMinute | int | Default minute |
| minHour | int | Range start hour |
| maxHour | int | Range end hour (exclusive of next hour block) |

- Preset values:

| Preset | Default | Range |
|--------|---------|-------|
| morning | 08:00 | 05:00 ~ 10:59 |
| noon | 12:00 | 11:00 ~ 14:59 |
| evening | 18:00 | 15:00 ~ 20:59 |
| bedtime | 22:00 | 21:00 ~ 01:59 |

- Add `TimeOfDay get defaultTimeOfDay`
- Add `bool isTimeInRange(int hour, int minute)` with bedtime midnight wrap-around handling
- Keep existing `label` field for backward compatibility

**Run:** `flutter test test/data/enums/dosage_timing_test.dart`
**Expected:** ALL PASS

**Commit:** `feat: add time metadata to DosageTiming enum`

---

## Phase 2: DosageTimeSlot Model

### Task 2.1: Write tests for DosageTimeSlot

**Files:**
- Create: `test/data/models/dosage_time_slot_test.dart`

**What to test:**
- `DosageTimeSlot(timing: DosageTiming.morning, time: "08:00")` creates correctly
- `DosageTimeSlot.withDefault(DosageTiming.morning)` produces time "08:00"
- `DosageTimeSlot.withDefault(DosageTiming.bedtime)` produces time "22:00"
- JSON serialization round-trip
- `timeOfDay` getter returns correct `TimeOfDay`

**Run:** `flutter test test/data/models/dosage_time_slot_test.dart`
**Expected:** FAIL (model not yet created)

**Commit:** `test: add DosageTimeSlot model tests`

---

### Task 2.2: Create DosageTimeSlot Freezed model

**Files:**
- Create: `lib/data/models/dosage_time_slot.dart`

**Model fields:**

| Field | Type | Description |
|-------|------|-------------|
| timing | DosageTiming | Preset (morning/noon/evening/bedtime) |
| time | String | Actual alert time ("HH:mm" format) |

**Requirements:**
- Freezed `@freezed` with `fromJson`
- Factory `DosageTimeSlot.withDefault(DosageTiming timing)` that uses `timing.defaultHour` / `timing.defaultMinute`
- Getter `TimeOfDay get timeOfDay` that parses the time string
- Private constructor `const DosageTimeSlot._();` for custom methods

**Run:**
```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/data/models/dosage_time_slot_test.dart
```
**Expected:** Codegen succeeds, ALL PASS

**Commit:** `feat: create DosageTimeSlot Freezed model`

---

## Phase 3: Schedule Model Refactor

### Task 3.1: Write tests for new Schedule.dosageSlots field

**Files:**
- Modify: `test/data/models/schedule_test.dart` (if exists, else create)

**What to test:**
- Schedule with `dosageSlots: [DosageTimeSlot.withDefault(DosageTiming.morning)]` creates correctly
- `timesPerDay` getter returns `dosageSlots.length`
- `times` getter returns extracted time strings from `dosageSlots`
- `dosageTimings` getter returns extracted DosageTiming values from `dosageSlots`
- JSON round-trip with dosageSlots
- Empty dosageSlots default

**Run:** `flutter test test/data/models/schedule_test.dart`
**Expected:** FAIL (fields not yet changed)

**Commit:** `test: add Schedule.dosageSlots tests`

---

### Task 3.2: Refactor Schedule model

**Files:**
- Modify: `lib/data/models/schedule.dart`

**Changes:**
- Remove fields: `timesPerDay` (int), `times` (List\<String\>), `dosageTimings` (List\<DosageTiming\>)
- Add field: `dosageSlots` (List\<DosageTimeSlot\>, default: [])
- Add import for `dosage_time_slot.dart`
- Add private constructor `const Schedule._();` for computed getters
- Add computed getters for backward compatibility:
  - `int get timesPerDay => dosageSlots.length;`
  - `List<String> get times => dosageSlots.map((s) => s.time).toList();`
  - `List<DosageTiming> get dosageTimings => dosageSlots.map((s) => s.timing).toList();`

**Run:**
```bash
dart run build_runner build --delete-conflicting-outputs
flutter test test/data/models/schedule_test.dart
```
**Expected:** Codegen succeeds, ALL PASS

**Important:** The computed getters ensure all existing code that reads `schedule.times`, `schedule.timesPerDay`, or `schedule.dosageTimings` continues to work without modification. This is a key design choice to minimize blast radius.

**Commit:** `feat: replace Schedule fields with dosageSlots`

---

### Task 3.3: Fix compilation errors from Schedule change

**Run:** `flutter analyze`

**Expected issues:** Any code that *sets* `timesPerDay`, `times`, or `dosageTimings` in a Schedule constructor or `copyWith` will fail (getters are read-only). The main callsites are:

| File | Issue |
|------|-------|
| `schedule_screen.dart:210-220` | Schedule() constructor uses old fields |
| `screenshot_seeder.dart:115-133` | Schedule() constructor uses old fields |
| `screenshot_data_seeder.dart:154-199` | Schedule() constructor uses old fields |
| Test files | Schedule() constructor uses old fields |

**Action:** Update each callsite to use `dosageSlots` instead. For each, replace the 3 old fields with a `dosageSlots` list built from the intended timings.

**Run:** `flutter analyze`
**Expected:** No errors

**Commit:** `refactor: update all Schedule construction callsites to dosageSlots`

---

## Phase 4: L10n Strings

### Task 4.1: Add new localization strings

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ja.arb`

**New keys needed:**

| Key | EN | JA | Usage |
|-----|----|----|-------|
| `selectDosageTiming` | "When do you take it?" | "いつ服用しますか？" | Section title in ScheduleScreen |
| `adjustTimes` | "Adjust Times" | "時間を調整" | Section title for time adjuster |
| `timeRangeHint` | "{timing}: {min}:00 ~ {max}:59" | "{timing}: {min}:00 ~ {max}:59" | Range hint below each time picker |
| `pleaseSelectAtLeastOneTiming` | "Please select at least one timing" | "少なくとも1つのタイミングを選択してください" | Validation message |
| `timeOutOfRange` | "Time must be between {min}:00 and {max}:59" | "時間は{min}:00から{max}:59の間である必要があります" | Validation error |

**Run:** `flutter gen-l10n`
**Expected:** Generation succeeds

**Commit:** `feat: add dosage timing redesign l10n strings`

---

## Phase 5: DosageTimeAdjuster Widget

### Task 5.1: Write widget test for DosageTimeAdjuster

**Files:**
- Create: `test/presentation/screens/schedule/widgets/dosage_time_adjuster_test.dart`

**What to test:**
- Renders one row per DosageTimeSlot
- Each row shows timing label and time picker
- Time picker respects range limits (tapping up/down stays within range)
- `onSlotsChanged` callback fires when time is adjusted
- Empty slots list renders nothing

**Run:** `flutter test test/presentation/screens/schedule/widgets/dosage_time_adjuster_test.dart`
**Expected:** FAIL (widget not yet created)

**Commit:** `test: add DosageTimeAdjuster widget tests`

---

### Task 5.2: Create DosageTimeAdjuster widget

**Files:**
- Create: `lib/presentation/screens/schedule/widgets/dosage_time_adjuster.dart`

**Props:**

| Prop | Type | Description |
|------|------|-------------|
| slots | List\<DosageTimeSlot\> | Current time slots |
| onSlotsChanged | ValueChanged\<List\<DosageTimeSlot\>\> | Callback when any time changes |

**Behavior:**
- For each slot, display a row: timing label (localized) + MpTimePicker
- MpTimePicker `onHourChanged` / `onMinuteChanged` must clamp values to the timing's `minHour`~`maxHour` range
- Bedtime range wrap-around: allow hours 21-23 and 0-1
- Sort slots by `DosageTiming.index` order
- Show range hint text below each time picker using `timeRangeHint` l10n

**Reuse:** `MpTimePicker` from `lib/presentation/shared/widgets/mp_time_picker.dart`
- Wrap hour change callback to clamp within `timing.minHour`~`timing.maxHour`
- Use `timing.isTimeInRange()` for validation

**Run:** `flutter test test/presentation/screens/schedule/widgets/dosage_time_adjuster_test.dart`
**Expected:** ALL PASS

**Commit:** `feat: create DosageTimeAdjuster widget`

---

## Phase 6: DosageTimingSelector Update

### Task 6.1: Update DosageTimingSelector to output DosageTimeSlots

**Files:**
- Modify: `lib/presentation/screens/schedule/widgets/dosage_timing_selector.dart`

**Current interface:**
- Input: `List<DosageTiming> selectedTimings`
- Output: `ValueChanged<List<DosageTiming>> onChanged`

**New interface:**
- Input: `List<DosageTimeSlot> selectedSlots`
- Output: `ValueChanged<List<DosageTimeSlot>> onChanged`

**Behavior change:**
- Selecting a timing: add `DosageTimeSlot.withDefault(timing)` to list
- Deselecting a timing: remove slot with matching `timing`
- `isSelected` check: `selectedSlots.any((s) => s.timing == timing)`
- Sort output by `DosageTiming.index`

**Run:** `flutter analyze`
**Expected:** No errors (ScheduleScreen will be updated in next phase)

**Commit:** `refactor: update DosageTimingSelector to use DosageTimeSlot`

---

## Phase 7: ScheduleScreen Rewrite

### Task 7.1: Rewrite ScheduleScreen UI flow

**Files:**
- Modify: `lib/presentation/screens/schedule/schedule_screen.dart`

**State changes:**
- Remove: `_dosageCount`, `_times`, `_dosageTimings`
- Add: `_dosageSlots` (List\<DosageTimeSlot\>)
- Keep: `_selectedType`, `_selectedDays`, `_intervalHours`

**New UI flow (all schedule types share):**

```
1. FrequencySelector (unchanged)
2. [IF specificDays] DaySelector (unchanged)
3. [IF interval] IntervalPicker (unchanged)
4. DosageTimingSelector (now outputs DosageTimeSlot list)
5. [IF _dosageSlots.isNotEmpty] DosageTimeAdjuster (new)
6. Save button
```

**Key changes:**
- Remove DosageMultiplier usage entirely
- Remove TimeSlotPicker usage entirely
- Remove `import` for `dosage_multiplier.dart` and `time_slot_picker.dart`
- Add `import` for `dosage_time_adjuster.dart`
- Section titles: use `selectDosageTiming` and `adjustTimes` l10n keys
- DosageTimingSelector position: immediately after frequency/day/interval selection
- DosageTimeAdjuster: appears dynamically when slots exist

**_saveSchedule() changes:**
- Validation: `_dosageSlots.isEmpty` -> show `pleaseSelectAtLeastOneTiming`
- Remove `_times.isEmpty` validation (times now derived from slots)
- Schedule constructor: use `dosageSlots: _dosageSlots` (no more `timesPerDay`, `times`, `dosageTimings`)

**Run:**
```bash
flutter analyze
flutter test
```
**Expected:** No errors, tests pass

**Commit:** `feat: rewrite ScheduleScreen with timing-driven flow`

---

## Phase 8: Display Screen Updates

### Task 8.1: Update MedicationDetailScreen

**Files:**
- Modify: `lib/presentation/screens/medications/medication_detail_screen.dart`

**Changes at lines 215-243:**
- The `schedule.times` and `schedule.dosageTimings` references already work via computed getters from Phase 3
- **However**, improve the display: combine timing label + time into one row instead of separate sections
- For each `dosageSlot` in `schedule.dosageSlots`, display: `"{timingLabel} {time}"` (e.g., "Morning 08:00")
- Replace the separate `times` and `dosageTimingTitle` sections with a unified "Dosage Schedule" section

**Run:** `flutter analyze`
**Expected:** No errors

**Commit:** `refactor: improve MedicationDetailScreen dosage display`

---

### Task 8.2: Update AffectedMedList (Travel screen)

**Files:**
- Modify: `lib/presentation/screens/travel/widgets/affected_med_list.dart`

**Changes at line 60 and 66:**
- Currently filters by `s.times.isNotEmpty` -> change to `s.dosageSlots.isNotEmpty`
- Currently iterates `schedule.times` -> change to iterate `schedule.dosageSlots` and extract `.time`
- Alternative: the computed `times` getter already works, but `dosageSlots.isNotEmpty` is more semantically correct for the filter

**Run:** `flutter analyze`
**Expected:** No errors

**Commit:** `refactor: update AffectedMedList to use dosageSlots`

---

### Task 8.3: Update ReminderProvider dosage timing label

**Files:**
- Modify: `lib/data/providers/reminder_provider.dart`

**Changes at lines 122-126:**
- Currently: `medSchedules.first.dosageTimings.map((t) => t.label).join('...')`
- This already works via the computed getter, but update to use localized names if desired
- No breaking change needed; verify only

**Run:** `flutter analyze`
**Expected:** No errors

**Commit:** (skip if no actual change needed)

---

## Phase 9: Cleanup

### Task 9.1: Delete DosageMultiplier widget

**Files:**
- Delete: `lib/presentation/screens/schedule/widgets/dosage_multiplier.dart`

**Pre-check:** Verify no remaining imports

**Run:**
```bash
# Search for any remaining references
grep -r "dosage_multiplier" lib/ test/
grep -r "DosageMultiplier" lib/ test/
flutter analyze
```
**Expected:** No references found, no errors

**Commit:** `refactor: remove DosageMultiplier widget`

---

### Task 9.2: Delete TimeSlotPicker widget

**Files:**
- Delete: `lib/presentation/screens/schedule/widgets/time_slot_picker.dart`

**Pre-check:** Verify no remaining imports

**Run:**
```bash
grep -r "time_slot_picker" lib/ test/
grep -r "TimeSlotPicker" lib/ test/
flutter analyze
```
**Expected:** No references found, no errors

**Commit:** `refactor: remove TimeSlotPicker widget`

---

### Task 9.3: Clean up unused l10n keys

**Files:**
- Modify: `lib/l10n/app_en.arb`
- Modify: `lib/l10n/app_ja.arb`

**Keys to evaluate for removal:**
- `howManyTimesPerDay` - no longer used (DosageMultiplier removed)
- `addAnotherTimeLabel` - no longer used (TimeSlotPicker removed)

**Run:**
```bash
grep -r "howManyTimesPerDay" lib/ --include="*.dart" | grep -v "app_localizations" | grep -v ".arb"
grep -r "addAnotherTimeLabel" lib/ --include="*.dart" | grep -v "app_localizations" | grep -v ".arb"
```

Only remove if zero non-l10n references found.

**Run:** `flutter gen-l10n && flutter analyze`
**Expected:** Generation succeeds, no errors

**Commit:** `chore: remove unused l10n keys`

---

## Phase 10: Screenshot Seeders & Test Fixtures

### Task 10.1: Update screenshot seeders

**Files:**
- Modify: `lib/core/utils/screenshot_seeder.dart`
- Modify: `lib/core/utils/screenshot_data_seeder.dart`

**Changes:** Replace all Schedule() constructors that use `timesPerDay` / `times` / `dosageTimings` with `dosageSlots`.

Example transformation:
- `timesPerDay: 2, times: ["08:00", "20:00"], dosageTimings: [morning, evening]`
- becomes: `dosageSlots: [DosageTimeSlot(timing: morning, time: "08:00"), DosageTimeSlot(timing: evening, time: "20:00")]`

**Run:** `flutter analyze`
**Expected:** No errors

**Commit:** `chore: update screenshot seeders to use dosageSlots`

---

### Task 10.2: Update test fixtures

**Files:**
- Modify: any test files using Schedule constructor with old fields
- Check: `test/data/providers/schedule_provider_test.dart`, `integration_test/utils/test_data.dart`

**Run:**
```bash
flutter test
flutter analyze
```
**Expected:** ALL PASS, no errors

**Commit:** `test: update test fixtures to use dosageSlots`

---

## Phase 11: Final Verification

### Task 11.1: Full build + analyze + test

**Run:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```
**Expected:** All green

---

### Task 11.2: Manual verification checklist

- [ ] `flutter analyze` passes with zero issues
- [ ] `build_runner build` succeeds
- [ ] All tests pass
- [ ] Each DosageTiming preset's range blocks out-of-range time selection
- [ ] Selecting/deselecting a timing dynamically adds/removes time slots
- [ ] All 3 schedule types (daily, specificDays, interval) work with new flow
- [ ] MedicationDetailScreen displays dosage timing + time correctly
- [ ] Travel AffectedMedList shows adjusted times correctly
- [ ] Reminders generate correctly from dosageSlots
- [ ] No references to deleted DosageMultiplier or TimeSlotPicker remain

**Commit:** (no commit, verification only)

---

## Dependency Graph

```
Phase 1 (DosageTiming enum)
    |
Phase 2 (DosageTimeSlot model) --- depends on Phase 1
    |
Phase 3 (Schedule model) --- depends on Phase 2
    |
    +--- Phase 4 (L10n) --- independent, can parallel with Phase 3
    |
Phase 5 (DosageTimeAdjuster) --- depends on Phase 1, 2, 4
    |
Phase 6 (DosageTimingSelector) --- depends on Phase 2
    |
Phase 7 (ScheduleScreen) --- depends on Phase 3, 5, 6
    |
Phase 8 (Display screens) --- depends on Phase 3
    |
Phase 9 (Cleanup) --- depends on Phase 7
    |
Phase 10 (Seeders/Tests) --- depends on Phase 3
    |
Phase 11 (Verification) --- depends on all
```

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Hive storage migration | Low | N/A | Design doc D9: app is unreleased, no migration needed |
| Computed getters miss edge cases | Medium | Medium | Tests in Phase 3.1 cover getter behavior |
| Bedtime midnight wrap-around bugs | Medium | High | Explicit tests in Phase 1.1 |
| Existing test breakage from Schedule change | High | Low | Phase 3.3 fixes all compilation errors; Phase 10.2 fixes test data |
