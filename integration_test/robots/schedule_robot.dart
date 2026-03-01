/// Robot/Page Object for schedule screen interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with the schedule screen
class ScheduleRobot {
  final WidgetTester tester;

  ScheduleRobot(this.tester);

  // ===== FINDERS =====

  // Schedule screen title (l10n.setSchedule = "Set Schedule")
  Finder get scheduleTitle => find.text('Set Schedule');

  // Frequency radio options (l10n keys: daily, specificDays, interval)
  Finder get dailyOption => find.text('Daily');
  Finder get specificDaysOption => find.text('Specific Days');
  Finder get intervalOption => find.text('Interval');

  // Dosage timing chips (l10n keys: dosageTimingMorning, etc.)
  Finder get morningChip => find.text('Morning');
  Finder get noonChip => find.text('Noon');
  Finder get eveningChip => find.text('Evening');
  Finder get bedtimeChip => find.text('Before Bed');

  // Save button (l10n.continueButton = "Continue")
  Finder get saveButton => find.text('Continue');

  // Section headers
  Finder get howOftenHeader => find.text('How often?');
  Finder get selectTimingHeader => find.text('When do you take it?');
  Finder get adjustTimesHeader => find.text('Adjust Times');
  Finder get whichDaysHeader => find.text('Which days?');

  // Navigation
  Finder get backButton => find.byIcon(Icons.arrow_back);

  // ===== ASSERTIONS =====

  /// Verify we're on the schedule screen
  Future<void> verifyOnScheduleScreen() async {
    await tester.pumpAndSettle();
    expect(scheduleTitle, findsOneWidget);
  }

  /// Verify frequency selector is visible
  Future<void> verifyFrequencySelectorVisible() async {
    await tester.pumpAndSettle();
    expect(dailyOption, findsOneWidget);
  }

  /// Verify dosage timing selector is visible
  Future<void> verifyTimingSelectorVisible() async {
    await tester.pumpAndSettle();
    expect(selectTimingHeader, findsOneWidget);
  }

  /// Verify time adjuster appears after selecting a timing
  Future<void> verifyTimeAdjusterVisible() async {
    await tester.pumpAndSettle();
    expect(adjustTimesHeader, findsOneWidget);
  }

  /// Verify validation error snackbar (l10n.pleaseSelectAtLeastOneTiming)
  Future<void> verifyTimingRequiredError() async {
    await tester.pumpAndSettle();
    expect(
      find.text('Please select at least one timing'),
      findsOneWidget,
    );
  }

  /// Verify day selector is visible (specific days mode)
  Future<void> verifyDaySelectorVisible() async {
    await tester.pumpAndSettle();
    expect(whichDaysHeader, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Select Daily frequency (default, but explicit)
  Future<void> selectDaily() async {
    await tester.tap(dailyOption);
    await tester.pumpAndSettle();
  }

  /// Select Specific Days frequency
  Future<void> selectSpecificDays() async {
    await tester.tap(specificDaysOption);
    await tester.pumpAndSettle();
  }

  /// Select Interval frequency
  Future<void> selectInterval() async {
    await tester.tap(intervalOption);
    await tester.pumpAndSettle();
  }

  /// Select a dosage timing chip by its text
  Future<void> selectTiming(String timing) async {
    await tester.tap(find.text(timing));
    await tester.pumpAndSettle();
  }

  /// Tap save/continue button
  Future<void> tapSave() async {
    await tester.scrollUntilVisible(
      saveButton,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  }

  /// Go back
  Future<void> tapBack() async {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
  }

  // ===== FLOWS =====

  /// Complete a basic daily schedule with morning timing
  Future<void> completeDailyMorningSchedule() async {
    await verifyOnScheduleScreen();
    await selectTiming('Morning');
    await tapSave();
  }
}
