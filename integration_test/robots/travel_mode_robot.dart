/// Robot/Page Object for Travel Mode screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_radio_option.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_toggle_switch.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/location_display.dart';

/// Robot pattern class for interacting with TravelModeScreen (/settings/travel)
class TravelModeRobot {
  final WidgetTester tester;

  TravelModeRobot(this.tester);

  // ===== FINDERS =====

  // Screen
  Finder get travelModeTitle => find.text('Travel Mode');

  // Toggle
  Finder get enableToggleLabel => find.text('Enable Travel Mode');
  Finder get enableToggle => find.byType(KdToggleSwitch);

  // Location display
  Finder get locationDisplay => find.byType(LocationDisplay);
  Finder get currentLocation => find.textContaining('Current:');
  Finder get homeLocation => find.textContaining('Home:');
  Finder get timeDifference => find.textContaining('Time difference:');

  // Mode selection
  Finder get fixedIntervalOption => find.text('Fixed Interval (Home Time)');
  Finder get localTimeOption => find.text('Local Time Adaptation');

  // Medications
  Finder get affectedMedsHeader => find.text('Affected Medications');
  Finder get noScheduledMeds => find.text('No scheduled medications');

  // Info box
  Finder get consultDoctorInfo =>
      find.textContaining('Consult your doctor');
  Finder get infoIcon => find.byIcon(Icons.info);

  // ===== ASSERTIONS =====

  /// Verify we're on the Travel Mode screen
  Future<void> verifyOnTravelModeScreen() async {
    await tester.pumpAndSettle();
    expect(travelModeTitle, findsOneWidget);
  }

  /// Verify initial disabled state
  Future<void> verifyDisabledState() async {
    await tester.pumpAndSettle();
    // Toggle label should be visible
    expect(enableToggleLabel, findsOneWidget);
    // Conditional UI should NOT be visible
    expect(fixedIntervalOption, findsNothing);
    expect(localTimeOption, findsNothing);
    expect(affectedMedsHeader, findsNothing);
    expect(consultDoctorInfo, findsNothing);
  }

  /// Verify enabled state — conditional UI visible
  Future<void> verifyEnabledState() async {
    await tester.pumpAndSettle();
    expect(fixedIntervalOption, findsOneWidget);
    expect(localTimeOption, findsOneWidget);
    expect(affectedMedsHeader, findsOneWidget);
    expect(consultDoctorInfo, findsOneWidget);
  }

  /// Verify location display is visible with all rows
  Future<void> verifyLocationDisplayVisible() async {
    await tester.pumpAndSettle();
    expect(locationDisplay, findsOneWidget);
    expect(currentLocation, findsOneWidget);
    expect(homeLocation, findsOneWidget);
    expect(timeDifference, findsOneWidget);
  }

  /// Verify Fixed Interval is the selected mode
  Future<void> verifyFixedIntervalSelected() async {
    await tester.pumpAndSettle();
    final widget = tester.widget<KdRadioOption<TimezoneMode>>(
      find.widgetWithText(KdRadioOption<TimezoneMode>, 'Fixed Interval (Home Time)'),
    );
    expect(widget.groupValue, TimezoneMode.fixedInterval);
  }

  /// Verify Local Time is the selected mode
  Future<void> verifyLocalTimeSelected() async {
    await tester.pumpAndSettle();
    final widget = tester.widget<KdRadioOption<TimezoneMode>>(
      find.widgetWithText(KdRadioOption<TimezoneMode>, 'Local Time Adaptation'),
    );
    expect(widget.groupValue, TimezoneMode.localTime);
  }

  /// Verify a medication name is displayed
  Future<void> verifyMedicationDisplayed(String name) async {
    await tester.pumpAndSettle();
    expect(find.text(name), findsOneWidget);
  }

  /// Verify no scheduled medications message
  Future<void> verifyNoScheduledMedications() async {
    await tester.pumpAndSettle();
    expect(noScheduledMeds, findsOneWidget);
  }

  /// Verify time is displayed (AM/PM format)
  Future<void> verifyTimeDisplayed() async {
    await tester.pumpAndSettle();
    // AffectedMedList shows times in 'h:mm a' format
    final amFinder = find.textContaining('AM');
    final pmFinder = find.textContaining('PM');
    expect(
      amFinder.evaluate().isNotEmpty || pmFinder.evaluate().isNotEmpty,
      isTrue,
      reason: 'Expected at least one time display with AM or PM',
    );
  }

  // ===== ACTIONS =====

  /// Tap the enable/disable toggle
  Future<void> tapEnableToggle() async {
    await tester.tap(enableToggle);
    await tester.pumpAndSettle();
  }

  /// Tap Fixed Interval option
  Future<void> tapFixedInterval() async {
    await tester.tap(fixedIntervalOption);
    await tester.pumpAndSettle();
  }

  /// Tap Local Time option
  Future<void> tapLocalTime() async {
    await tester.tap(localTimeOption);
    await tester.pumpAndSettle();
  }
}
