import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/presentation/screens/home/widgets/medication_timeline.dart';
import 'package:my_pill/presentation/screens/home/widgets/timeline_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

import '../../../../helpers/widget_test_helpers.dart';

class FakeTodayReminders extends TodayReminders {
  final List<Reminder> _reminders;
  FakeTodayReminders(this._reminders);

  @override
  Future<List<Reminder>> build() async => _reminders;
}

class FakeMedicationList extends MedicationList {
  final List<Medication> _meds;
  FakeMedicationList(this._meds);

  @override
  Future<List<Medication>> build() async => _meds;
}

Medication _makeMedication({
  String id = 'med-1',
  String name = 'Aspirin',
  double dosage = 100,
  DosageUnit unit = DosageUnit.mg,
}) {
  return Medication(
    id: id,
    name: name,
    dosage: dosage,
    dosageUnit: unit,
    shape: PillShape.round,
    color: PillColor.white,
    createdAt: DateTime(2024, 1, 1),
  );
}

Reminder _makeReminder({
  String id = 'r1',
  String medicationId = 'med-1',
  ReminderStatus status = ReminderStatus.pending,
  DateTime? scheduledTime,
}) {
  return Reminder(
    id: id,
    medicationId: medicationId,
    scheduledTime: scheduledTime ?? DateTime(2024, 6, 1, 8, 0),
    status: status,
  );
}

List<dynamic> _buildOverrides({
  required List<Reminder> reminders,
  required List<Medication> medications,
}) {
  final overrides = <dynamic>[
    todayRemindersProvider.overrideWith(() => FakeTodayReminders(reminders)),
    medicationListProvider.overrideWith(() => FakeMedicationList(medications)),
  ];

  // Override each individual medication provider
  for (final med in medications) {
    overrides.add(
      medicationProvider(med.id).overrideWith((ref) async => med),
    );
  }

  return overrides;
}

void main() {
  group('MedicationTimeline', () {
    testWidgets('shows empty state when no reminders', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: [], medications: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MpEmptyState), findsOneWidget);
    });

    testWidgets('shows empty state with calendar icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: [], medications: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('renders timeline card for each reminder with medication', (tester) async {
      final med1 = _makeMedication(id: 'med-1', name: 'Aspirin');
      final med2 = _makeMedication(id: 'med-2', name: 'Vitamin C');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1'),
        _makeReminder(id: 'r2', medicationId: 'med-2'),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(
            reminders: reminders,
            medications: [med1, med2],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsNWidgets(2));
      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Vitamin C'), findsOneWidget);
    });

    testWidgets('renders medication name in timeline card', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Metformin');
      final reminders = [_makeReminder(id: 'r1', medicationId: 'med-1')];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(
            reminders: reminders,
            medications: [med],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Metformin'), findsOneWidget);
    });

    testWidgets('renders empty state when no reminders', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: [], medications: []),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without crashing with empty data
      expect(find.byType(MedicationTimeline), findsOneWidget);
    });

    testWidgets('renders taken status reminder', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Lisinopril');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1', status: ReminderStatus.taken),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      // taken status shows check_circle icon
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('renders pending reminder with mark-taken button', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Atorvastatin');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1', status: ReminderStatus.pending),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
    });

    testWidgets('renders skipped reminder without action button', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Omeprazole');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1', status: ReminderStatus.skipped),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });

    testWidgets('renders formatted time in card', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Aspirin');
      final reminders = [
        _makeReminder(
          id: 'r1',
          medicationId: 'med-1',
          scheduledTime: DateTime(2024, 6, 1, 9, 30),
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('9:30 AM'), findsOneWidget);
    });

    testWidgets('renders single reminder correctly', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Pantoprazole', dosage: 40);
      final reminders = [_makeReminder(id: 'r1', medicationId: 'med-1')];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      expect(find.text('Pantoprazole'), findsOneWidget);
    });

    testWidgets('shows loading indicator while reminders are loading', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: [
            todayRemindersProvider.overrideWith(() => _SlowTodayReminders()),
            medicationListProvider.overrideWith(
              () => FakeMedicationList([]),
            ),
          ],
        ),
      );
      // Pump once without settling to catch loading state
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message when reminders fail to load', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: [
            todayRemindersProvider.overrideWith(() => _ErrorTodayReminders()),
            medicationListProvider.overrideWith(
              () => FakeMedicationList([]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n key: errorLoadingReminders -> "Error loading reminders"
      expect(find.text('Error loading reminders'), findsOneWidget);
    });

    testWidgets('renders missed reminder badge', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Metoprolol');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1', status: ReminderStatus.missed),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      // l10n key: missed -> "Missed"
      expect(find.text('Missed'), findsOneWidget);
    });

    testWidgets('renders snoozed reminder badge', (tester) async {
      final med = _makeMedication(id: 'med-1', name: 'Ibuprofen');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1', status: ReminderStatus.snoozed),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(reminders: reminders, medications: [med]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsOneWidget);
      // l10n key: snoozed -> "Snoozed"
      expect(find.text('Snoozed'), findsOneWidget);
    });

    testWidgets('hides card when medication not found (null medication)', (tester) async {
      // Reminder references a medication id that has no matching medication
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'unknown-med-id'),
      ];

      // Override the individual medicationProvider to return null
      final overrides = <dynamic>[
        todayRemindersProvider.overrideWith(() => FakeTodayReminders(reminders)),
        medicationListProvider.overrideWith(() => FakeMedicationList([])),
        medicationProvider('unknown-med-id').overrideWith((ref) async => null),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: overrides,
        ),
      );
      await tester.pumpAndSettle();

      // No TimelineCard rendered when medication is null
      expect(find.byType(TimelineCard), findsNothing);
    });

    testWidgets('hides card when individual medication provider errors', (tester) async {
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'bad-med-id'),
      ];

      final overrides = <dynamic>[
        todayRemindersProvider.overrideWith(() => FakeTodayReminders(reminders)),
        medicationListProvider.overrideWith(() => FakeMedicationList([])),
        medicationProvider('bad-med-id').overrideWith(
          (ref) async => throw Exception('Medication load failed'),
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: overrides,
        ),
      );
      await tester.pumpAndSettle();

      // Error branch in inner Consumer renders SizedBox.shrink → no TimelineCard
      expect(find.byType(TimelineCard), findsNothing);
    });

    testWidgets('renders multiple reminders with spacing between them', (tester) async {
      final med1 = _makeMedication(id: 'med-1', name: 'Drug A');
      final med2 = _makeMedication(id: 'med-2', name: 'Drug B');
      final med3 = _makeMedication(id: 'med-3', name: 'Drug C');
      final reminders = [
        _makeReminder(id: 'r1', medicationId: 'med-1'),
        _makeReminder(id: 'r2', medicationId: 'med-2'),
        _makeReminder(id: 'r3', medicationId: 'med-3'),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const MedicationTimeline(),
          overrides: _buildOverrides(
            reminders: reminders,
            medications: [med1, med2, med3],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TimelineCard), findsNWidgets(3));
    });
  });
}

// Notifier that stays in loading state for testing
class _SlowTodayReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() {
    // Use a Completer that never completes to avoid pending timer issues
    return Completer<List<Reminder>>().future;
  }
}

// Notifier that throws an error for testing error state
class _ErrorTodayReminders extends TodayReminders {
  @override
  Future<List<Reminder>> build() async =>
      throw Exception('Failed to load reminders');
}
