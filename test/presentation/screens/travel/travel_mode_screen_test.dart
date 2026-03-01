import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/data/services/timezone_service.dart';
import 'package:kusuridoki/presentation/screens/travel/travel_mode_screen.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/affected_med_list.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/location_display.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/timezone_mode_selector.dart';

import '../../../helpers/widget_test_helpers.dart';

// ── Fake TimezoneSettings ─────────────────────────────────────────────────────

class _FakeTimezoneSettings extends TimezoneSettings {
  final TimezoneState _state;
  _FakeTimezoneSettings(this._state);

  @override
  TimezoneState build() => _state;

  @override
  void toggleEnabled() {
    final current = state;
    state = (
      enabled: !current.enabled,
      mode: current.mode,
      homeTimezone: current.homeTimezone,
      currentTimezone: current.currentTimezone,
    );
  }
}

const _disabledState = (
  enabled: false,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'America/New_York',
);

const _enabledState = (
  enabled: true,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'America/New_York',
);

// ── Fake Medication/Schedule providers ────────────────────────────────────────

class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

class _FakePopulatedMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [
    Medication(
      id: 'med1',
      name: 'Aspirin',
      dosage: 100,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.round,
      color: PillColor.white,
      createdAt: DateTime(2024),
    ),
  ];
}

class _FakePopulatedScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [
    const Schedule(
      id: 'sch1',
      medicationId: 'med1',
      type: ScheduleType.daily,
      dosageSlots: [
        DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
      ],
      isActive: true,
    ),
  ];
}

class _FakeEmptyScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [];
}

// ── Helpers ───────────────────────────────────────────────────────────────────

List<dynamic> _buildOverrides({
  TimezoneState timezoneState = _disabledState,
  bool populateMeds = false,
}) {
  return [
    timezoneSettingsProvider.overrideWith(
      () => _FakeTimezoneSettings(timezoneState),
    ),
    timezoneServiceProvider.overrideWith((ref) => TimezoneService()),
    medicationListProvider.overrideWith(
      populateMeds
          ? () => _FakePopulatedMedicationList()
          : () => _FakeEmptyMedicationList(),
    ),
    scheduleListProvider.overrideWith(
      populateMeds
          ? () => _FakePopulatedScheduleList()
          : () => _FakeEmptyScheduleList(),
    ),
  ];
}

void main() {
  setUpAll(() async {
    await TimezoneService.initialize();
  });

  group('TravelModeScreen', () {
    testWidgets('renders app bar with travel mode title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: travelMode -> "Travel Mode"
      expect(find.text('Travel Mode'), findsOneWidget);
    });

    testWidgets('shows toggle switch with enable label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: enableTravelMode -> "Enable Travel Mode"
      expect(find.text('Enable Travel Mode'), findsOneWidget);
    });

    testWidgets('shows LocationDisplay always', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LocationDisplay), findsOneWidget);
    });

    testWidgets('hides mode selector when disabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(timezoneState: _disabledState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimezoneModeSelector), findsNothing);
    });

    testWidgets('hides affected meds when disabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(timezoneState: _disabledState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AffectedMedList), findsNothing);
    });

    testWidgets('hides consult doctor info when disabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(timezoneState: _disabledState),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.info), findsNothing);
    });

    testWidgets('shows mode selector when enabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(
            timezoneState: _enabledState,
            populateMeds: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimezoneModeSelector), findsOneWidget);
    });

    testWidgets('shows affected medications header when enabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(
            timezoneState: _enabledState,
            populateMeds: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: affectedMedications -> "Affected Medications"
      expect(find.text('Affected Medications'), findsOneWidget);
    });

    testWidgets('shows affected med list when enabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(
            timezoneState: _enabledState,
            populateMeds: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AffectedMedList), findsOneWidget);
    });

    testWidgets('shows consult doctor info box when enabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(
            timezoneState: _enabledState,
            populateMeds: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Need to scroll to see the info box
      await tester.scrollUntilVisible(
        find.byIcon(Icons.info),
        200,
        scrollable: find.byType(Scrollable).first,
      );

      expect(find.byIcon(Icons.info), findsOneWidget);
      // l10n: consultDoctor
      expect(
        find.textContaining('Consult'),
        findsAtLeastNWidgets(1),
      );
    });

    testWidgets('toggle switch changes enabled state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const TravelModeScreen(),
          overrides: _buildOverrides(timezoneState: _disabledState),
        ),
      );
      await tester.pumpAndSettle();

      // Initially: no TimezoneModeSelector (disabled)
      expect(find.byType(TimezoneModeSelector), findsNothing);

      // Tap the toggle (GestureDetector inside MpToggleSwitch)
      // The toggle is in a Row with label "Enable Travel Mode"
      // Find the toggle area — tap on the switch itself
      final toggleFinder = find.byType(AnimatedContainer).first;
      await tester.tap(toggleFinder);
      await tester.pumpAndSettle();

      // After toggle: TimezoneModeSelector should appear
      expect(find.byType(TimezoneModeSelector), findsOneWidget);
    });
  });
}
