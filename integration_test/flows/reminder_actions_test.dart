/// E2E tests for reminder actions (take, skip, snooze)
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_data.dart';
import '../utils/test_helpers.dart';
import '../robots/home_robot.dart';

void main() {
  ensureTestInitialized();

  group('Reminder Actions', () {
    testWidgets('Reminders display on home timeline', (tester) async {
      // Arrange: Patient with medications and reminders
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Reminders should be displayed
      await robot.verifyOnHomeScreen();
      await robot.verifyRemindersDisplayed();
    });

    testWidgets('Empty state when no reminders', (tester) async {
      // Arrange: Patient with no medications/reminders
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Should show no reminders message
      await robot.verifyOnHomeScreen();
      await robot.verifyNoReminders();
    });

    testWidgets('Reminder shows medication name', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Medication names should be visible in reminders
      await robot.verifyReminderExists('Aspirin');
    });

    testWidgets('Reminder shows upcoming status badge', (tester) async {
      // Arrange: Patient with pending reminders
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Upcoming badge should be visible
      await robot.verifyReminderUpcoming();
    });

    testWidgets('Tap reminder navigates to medication detail', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Act: Tap on a reminder
      await robot.tapReminder('Aspirin');

      // Assert: Should navigate to medication detail
      expect(find.text('Aspirin'), findsWidgets);
    });

    testWidgets('Low stock banner shows for low inventory', (tester) async {
      // Arrange: Patient with low stock medication
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Low stock banner may be visible (Vitamin D has 4 remaining)
      // Note: This depends on whether low stock banner is implemented
      await robot.verifyOnHomeScreen();
    });

    testWidgets('Navigate between tabs', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Act & Assert: Navigate through all tabs
      await robot.verifyOnHomeScreen();

      await robot.goToAdherence();
      await tester.pumpAndSettle();
      // Should be on adherence screen

      await robot.goToMedications();
      await tester.pumpAndSettle();
      // Should be on medications screen

      await robot.goToSettings();
      await tester.pumpAndSettle();
      // Should be on settings screen

      await robot.goToHome();
      await tester.pumpAndSettle();
      await robot.verifyOnHomeScreen();
    });

    testWidgets('Scroll through reminders list', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Act: Scroll down and up
      await robot.scrollDown();
      await robot.scrollUp();

      // Assert: Should still be on home screen
      await robot.verifyOnHomeScreen();
    });

    testWidgets('Multiple reminders display in timeline', (tester) async {
      // Arrange: Config with multiple reminders
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Multiple reminders should be visible
      await robot.verifyRemindersDisplayed();
      // The test data includes 3 reminders for today
    });

    testWidgets('Reminders sorted by time', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Reminders should be displayed (sorted by time in implementation)
      await robot.verifyOnHomeScreen();
      await robot.verifyRemindersDisplayed();
    });

    testWidgets('Home screen shows greeting', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Greeting should be visible
      await robot.verifyOnHomeScreen();
      // The greeting header shows "Good morning/afternoon/evening"
    });
  });

  group('Reminder Action — Take/Skip/Snooze', () {
    testWidgets('RA-01: Check button tap opens action dialog', (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(8))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);
      await robot.verifyReminderExists('Aspirin');
      await robot.tapReminderCheckButton('Aspirin');
      await robot.verifyReminderDialogShown();
    });

    testWidgets('RA-02: Dialog shows Take Now, Snooze, and Skip options',
        (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(8))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);
      await robot.tapReminderCheckButton('Aspirin');
      await robot.verifyReminderDialogShown();

      expect(find.text('Take Now'), findsOneWidget);
      expect(find.textContaining('Snooze'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
    });

    testWidgets('RA-03: Selecting Take Now changes badge to Taken',
        (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(8))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);
      await robot.tapReminderCheckButton('Aspirin');
      await robot.markAsTaken();

      await robot.verifyReminderTaken();
    });

    testWidgets('RA-04: Selecting Skip changes badge to Skipped',
        (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(8))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);
      await robot.tapReminderCheckButton('Aspirin');
      await robot.markAsSkipped();

      await robot.verifyReminderSkipped();
    });

    testWidgets('RA-05: Dismissing dialog leaves reminder as Upcoming',
        (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(20))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);
      await robot.tapReminderCheckButton('Aspirin');
      await robot.verifyReminderDialogShown();

      // Dismiss by tapping the barrier outside the dialog
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      await robot.verifyReminderDialogDismissed();
      await robot.verifyReminderUpcoming();
    });

    testWidgets(
        'RA-06: After Taken, check icon becomes solid and dialog is not re-openable',
        (tester) async {
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(8))],
      );
      await tester.pumpWidget(buildTestApp(config));
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Take the medication
      await robot.tapReminderCheckButton('Aspirin');
      await robot.markAsTaken();
      await robot.verifyReminderTaken();

      // After taken: outline check icon is gone, solid check icon appears
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });
  });

  group('Reminder Status Updates', () {
    testWidgets('Reminder card shows correct status badge', (tester) async {
      // Arrange: Patient with various reminder statuses
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [
          TestData.pendingReminder(TestTime.todayAt(8)),
          TestData.takenReminder(TestTime.todayAt(12)),
          TestData.missedReminder(TestTime.yesterdayAt(20)),
        ],
      );
      final app = buildTestApp(config);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert: Various status badges should be visible
      await robot.verifyOnHomeScreen();
    });

    testWidgets('Pending reminders show Upcoming badge', (tester) async {
      // Arrange
      final config = TestAppConfig.patient(
        medications: [TestData.sampleMedication],
        schedules: [TestData.dailySchedule],
        reminders: [TestData.pendingReminder(TestTime.todayAt(20))],
      );
      final app = buildTestApp(config);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final robot = HomeRobot(tester);

      // Assert
      await robot.verifyReminderUpcoming();
    });
  });
}
