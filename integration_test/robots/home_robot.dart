/// Robot/Page Object for home screen and reminder interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with home screen and reminders
class HomeRobot {
  final WidgetTester tester;

  HomeRobot(this.tester);

  // ===== FINDERS =====

  // Home screen elements
  Finder get homeIcon => find.byIcon(Icons.home);
  Finder get greetingText => find.textContaining('Good');
  Finder get noRemindersText => find.text('No reminders for today');

  // Timeline/Reminder elements
  Finder get timelineCards => find.byType(Card);

  // Status badges
  Finder get upcomingBadge => find.text('Upcoming');
  Finder get takenBadge => find.text('Taken');
  Finder get skippedBadge => find.text('Skipped');
  Finder get missedBadge => find.text('Missed');
  Finder get snoozedBadge => find.text('Snoozed');

  // Action buttons (typically in a bottom sheet or card actions)
  Finder get takeButton => find.text('Take');
  Finder get skipButton => find.text('Skip');
  Finder get snoozeButton => find.text('Snooze');

  // Low stock banner
  Finder get lowStockBanner => find.textContaining('Low Stock');

  // Bottom navigation - use finders that match either active or inactive icons
  Finder get homeTab => find.byWidgetPredicate(
    (widget) => widget is Icon &&
      (widget.icon == Icons.home || widget.icon == Icons.home_outlined),
  );

  Finder get adherenceTab => find.byWidgetPredicate(
    (widget) => widget is Icon &&
      (widget.icon == Icons.calendar_today || widget.icon == Icons.calendar_today_outlined),
  );

  Finder get medicationsTab => find.byWidgetPredicate(
    (widget) => widget is Icon &&
      (widget.icon == Icons.medication || widget.icon == Icons.medication_outlined),
  );

  Finder get settingsTab => find.byWidgetPredicate(
    (widget) => widget is Icon &&
      (widget.icon == Icons.settings || widget.icon == Icons.settings_outlined),
  );

  /// Find a reminder card by medication name
  Finder reminderCard(String medicationName) => find.text(medicationName);

  /// Find a time display
  Finder timeText(String time) => find.text(time);

  // ===== ASSERTIONS =====

  /// Verify we're on the home screen
  Future<void> verifyOnHomeScreen() async {
    await tester.pumpAndSettle();
    // Home screen should have the greeting header
    expect(find.byType(Scaffold), findsWidgets);
  }

  /// Verify no reminders state
  Future<void> verifyNoReminders() async {
    await tester.pumpAndSettle();
    expect(noRemindersText, findsOneWidget);
  }

  /// Verify reminders are displayed
  Future<void> verifyRemindersDisplayed() async {
    await tester.pumpAndSettle();
    expect(noRemindersText, findsNothing);
  }

  /// Verify a specific reminder exists
  Future<void> verifyReminderExists(String medicationName) async {
    await tester.pumpAndSettle();
    expect(reminderCard(medicationName), findsWidgets);
  }

  /// Verify reminder status is "Taken"
  Future<void> verifyReminderTaken() async {
    await tester.pumpAndSettle();
    expect(takenBadge, findsWidgets);
  }

  /// Verify reminder status is "Skipped"
  Future<void> verifyReminderSkipped() async {
    await tester.pumpAndSettle();
    expect(skippedBadge, findsWidgets);
  }

  /// Verify reminder status is "Snoozed"
  Future<void> verifyReminderSnoozed() async {
    await tester.pumpAndSettle();
    expect(snoozedBadge, findsWidgets);
  }

  /// Verify reminder status is "Missed"
  Future<void> verifyReminderMissed() async {
    await tester.pumpAndSettle();
    expect(missedBadge, findsWidgets);
  }

  /// Verify reminder status is "Upcoming"
  Future<void> verifyReminderUpcoming() async {
    await tester.pumpAndSettle();
    expect(upcomingBadge, findsWidgets);
  }

  /// Verify low stock banner is shown
  Future<void> verifyLowStockBannerShown() async {
    await tester.pumpAndSettle();
    expect(lowStockBanner, findsWidgets);
  }

  /// Verify low stock banner is not shown
  Future<void> verifyNoLowStockBanner() async {
    await tester.pumpAndSettle();
    expect(lowStockBanner, findsNothing);
  }

  // ===== ACTIONS =====

  /// Tap on a reminder card
  Future<void> tapReminder(String medicationName) async {
    await tester.tap(reminderCard(medicationName).first);
    await tester.pumpAndSettle();
  }

  /// Mark reminder as taken
  Future<void> markAsTaken() async {
    await tester.tap(takeButton);
    await tester.pumpAndSettle();
  }

  /// Mark reminder as skipped
  Future<void> markAsSkipped() async {
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
  }

  /// Snooze reminder
  Future<void> snoozeReminder() async {
    await tester.tap(snoozeButton);
    await tester.pumpAndSettle();
  }

  /// Navigate to home tab
  Future<void> goToHome() async {
    // Wait for navigation bar to be rendered (splash screen may still be showing)
    const maxAttempts = 30; // 6 seconds total (2s splash + 4s buffer)
    const attemptDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await tester.pump(attemptDelay);

      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab.first);
        await tester.pumpAndSettle();
        return;
      }
    }

    // If still not found, fail with descriptive error
    throw TestFailure(
      'Home tab not found after ${maxAttempts * attemptDelay.inMilliseconds}ms. '
      'Navigation bar may not be rendered yet.',
    );
  }

  /// Navigate to adherence tab
  Future<void> goToAdherence() async {
    // Wait for navigation bar to be rendered (splash screen may still be showing)
    const maxAttempts = 30; // 6 seconds total (2s splash + 4s buffer)
    const attemptDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await tester.pump(attemptDelay);

      if (adherenceTab.evaluate().isNotEmpty) {
        await tester.tap(adherenceTab.first);
        await tester.pumpAndSettle();
        return;
      }
    }

    // If still not found, fail with descriptive error
    throw TestFailure(
      'Adherence tab not found after ${maxAttempts * attemptDelay.inMilliseconds}ms. '
      'Navigation bar may not be rendered yet.',
    );
  }

  /// Navigate to medications tab
  Future<void> goToMedications() async {
    // Wait for navigation bar to be rendered (splash screen may still be showing)
    const maxAttempts = 30; // 6 seconds total (2s splash + 4s buffer)
    const attemptDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await tester.pump(attemptDelay);

      if (medicationsTab.evaluate().isNotEmpty) {
        await tester.tap(medicationsTab.first);
        await tester.pumpAndSettle();
        return;
      }
    }

    // If still not found, fail with descriptive error
    throw TestFailure(
      'Medications tab not found after ${maxAttempts * attemptDelay.inMilliseconds}ms. '
      'Navigation bar may not be rendered yet.',
    );
  }

  /// Navigate to settings tab
  Future<void> goToSettings() async {
    // Wait for navigation bar to be rendered (splash screen may still be showing)
    const maxAttempts = 30; // 6 seconds total (2s splash + 4s buffer)
    const attemptDelay = Duration(milliseconds: 200);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      await tester.pump(attemptDelay);

      if (settingsTab.evaluate().isNotEmpty) {
        await tester.tap(settingsTab.first);
        await tester.pumpAndSettle();
        return;
      }
    }

    // If still not found, fail with descriptive error
    throw TestFailure(
      'Settings tab not found after ${maxAttempts * attemptDelay.inMilliseconds}ms. '
      'Navigation bar may not be rendered yet.',
    );
  }

  /// Long press on a reminder to show action menu
  Future<void> longPressReminder(String medicationName) async {
    await tester.longPress(reminderCard(medicationName).first);
    await tester.pumpAndSettle();
  }

  /// Scroll down to see more reminders
  Future<void> scrollDown() async {
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
  }

  /// Scroll up
  Future<void> scrollUp() async {
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, 200),
    );
    await tester.pumpAndSettle();
  }

  /// Pull to refresh
  Future<void> pullToRefresh() async {
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, 300),
    );
    await tester.pumpAndSettle();
  }

  // ===== FLOWS =====

  /// Take a medication reminder
  Future<void> takeReminder(String medicationName) async {
    await tapReminder(medicationName);
    await markAsTaken();
  }

  /// Skip a medication reminder
  Future<void> skipReminder(String medicationName) async {
    await tapReminder(medicationName);
    await markAsSkipped();
  }

  /// Snooze a medication reminder
  Future<void> snoozeReminderFor(String medicationName) async {
    await tapReminder(medicationName);
    await snoozeReminder();
  }
}
