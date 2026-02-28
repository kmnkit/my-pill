import 'dart:async';

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
import 'package:kusuridoki/presentation/screens/travel/widgets/affected_med_list.dart';

import '../../../../helpers/widget_test_helpers.dart';

// ── Fake TimezoneSettings ─────────────────────────────────────────────────────

class _FakeTimezoneSettings extends TimezoneSettings {
  final TimezoneState _state;
  _FakeTimezoneSettings(this._state);

  @override
  TimezoneState build() => _state;
}

const _defaultTimezoneState = (
  enabled: true,
  mode: TimezoneMode.fixedInterval,
  homeTimezone: 'Asia/Tokyo',
  currentTimezone: 'Asia/Tokyo', // same TZ for predictable time display
);

// ── Fake MedicationList variants ──────────────────────────────────────────────

class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

class _FakeLoadingMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() => Completer<List<Medication>>().future;
}

class _FakeErrorMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => throw Exception('load error');
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

class _FakeMultiMedicationList extends MedicationList {
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
    Medication(
      id: 'med2',
      name: 'Vitamin C',
      dosage: 500,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.capsule,
      color: PillColor.orange,
      createdAt: DateTime(2024),
    ),
  ];
}

// ── Fake ScheduleList variants ────────────────────────────────────────────────

class _FakeEmptyScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [];
}

class _FakeLoadingScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() => Completer<List<Schedule>>().future;
}

class _FakeErrorScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => throw Exception('schedule error');
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

class _FakeInactiveScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [
    const Schedule(
      id: 'sch1',
      medicationId: 'med1',
      type: ScheduleType.daily,
      dosageSlots: [
        DosageTimeSlot(timing: DosageTiming.morning, time: '08:00'),
      ],
      isActive: false,
    ),
  ];
}

class _FakeInvalidTimeScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [
    const Schedule(
      id: 'sch1',
      medicationId: 'med1',
      type: ScheduleType.daily,
      dosageSlots: [
        DosageTimeSlot(timing: DosageTiming.morning, time: 'invalid'),
      ],
      isActive: true,
    ),
  ];
}

class _FakeMultiScheduleList extends ScheduleList {
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
    const Schedule(
      id: 'sch2',
      medicationId: 'med2',
      type: ScheduleType.daily,
      dosageSlots: [
        DosageTimeSlot(timing: DosageTiming.morning, time: '09:00'),
      ],
      isActive: true,
    ),
  ];
}

// ── Helpers ───────────────────────────────────────────────────────────────────

List<dynamic> _buildOverrides({
  MedicationList Function()? medicationFactory,
  ScheduleList Function()? scheduleFactory,
  TimezoneState timezoneState = _defaultTimezoneState,
}) {
  return [
    timezoneSettingsProvider.overrideWith(
      () => _FakeTimezoneSettings(timezoneState),
    ),
    timezoneServiceProvider.overrideWith((ref) => TimezoneService()),
    medicationListProvider.overrideWith(
      medicationFactory ?? () => _FakeEmptyMedicationList(),
    ),
    scheduleListProvider.overrideWith(
      scheduleFactory ?? () => _FakeEmptyScheduleList(),
    ),
  ];
}

void main() {
  setUpAll(() async {
    await TimezoneService.initialize();
  });

  group('AffectedMedList', () {
    testWidgets('shows loading indicator while medications load', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakeLoadingMedicationList(),
            scheduleFactory: () => _FakePopulatedScheduleList(),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows loading indicator while schedules load', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakeLoadingScheduleList(),
          ),
        ),
      );
      // pump once for medications to resolve, then check schedule loading
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on medication load failure', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakeErrorMedicationList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error loading medications'), findsOneWidget);
    });

    testWidgets('shows error message on schedule load failure', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakeErrorScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error loading schedule'), findsOneWidget);
    });

    testWidgets('shows no scheduled medications when empty', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakeEmptyScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No scheduled medications'), findsOneWidget);
    });

    testWidgets('shows no scheduled when no active schedules', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakeInactiveScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No scheduled medications'), findsOneWidget);
    });

    testWidgets('displays medication name with schedule', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakePopulatedScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
    });

    testWidgets('displays adjusted time in home/local format', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakePopulatedScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // With same timezone (Asia/Tokyo -> Asia/Tokyo), times should be equal
      // Expect to find text containing "AM" or "PM" (time format)
      expect(find.textContaining('8:00 AM'), findsOneWidget);
    });

    testWidgets('skips invalid time format', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakePopulatedMedicationList(),
            scheduleFactory: () => _FakeInvalidTimeScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Invalid time gets skipped, so no medication card rendered
      expect(find.text('No scheduled medications'), findsOneWidget);
    });

    testWidgets('handles multiple medications with schedules', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const AffectedMedList(),
          overrides: _buildOverrides(
            medicationFactory: () => _FakeMultiMedicationList(),
            scheduleFactory: () => _FakeMultiScheduleList(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Vitamin C'), findsOneWidget);
    });
  });
}
