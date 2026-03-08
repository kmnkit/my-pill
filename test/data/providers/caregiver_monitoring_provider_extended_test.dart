// SC-CAR-003 through SC-CAR-010
// Tests for CaregiverMonitoringProvider computed providers and mapping functions
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

Medication _makeMed(String id, String name) => Medication(
  id: id,
  name: name,
  dosage: 1,
  dosageUnit: DosageUnit.pills,
  shape: PillShape.round,
  color: PillColor.white,
  createdAt: DateTime(2026, 1, 1),
);

Reminder _makeReminder(
  String id,
  String medicationId,
  DateTime scheduledTime,
  ReminderStatus status,
) => Reminder(
  id: id,
  medicationId: medicationId,
  scheduledTime: scheduledTime,
  status: status,
);

void main() {
  // ---------------------------------------------------------------------------
  // SC-CAR-003: patientDailyAdherence returns null when no reminders today
  // ---------------------------------------------------------------------------
  group('patientDailyAdherenceProvider — SC-CAR-003', () {
    test('returns null when today has no reminders', () async {
      final container = ProviderContainer(
        overrides: [
          patientRemindersProvider(
            'patient-1',
          ).overrideWith((ref) => Stream.value([])),
        ],
      );
      addTearDown(container.dispose);

      container.listen(patientRemindersProvider('patient-1'), (_, _) {});

      final result = await container.read(
        patientDailyAdherenceProvider('patient-1').future,
      );
      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-004: patientDailyAdherence calculates correctly from today's reminders
  // ---------------------------------------------------------------------------
  group('patientDailyAdherenceProvider — SC-CAR-004', () {
    test('returns ~66.67 for 2 taken + 1 missed today', () async {
      final today = DateTime.now();
      final reminders = [
        _makeReminder(
          'r1',
          'med-1',
          DateTime(today.year, today.month, today.day, 8, 0),
          ReminderStatus.taken,
        ),
        _makeReminder(
          'r2',
          'med-1',
          DateTime(today.year, today.month, today.day, 12, 0),
          ReminderStatus.taken,
        ),
        _makeReminder(
          'r3',
          'med-1',
          DateTime(today.year, today.month, today.day, 20, 0),
          ReminderStatus.missed,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          patientRemindersProvider(
            'patient-1',
          ).overrideWith((ref) => Stream.value(reminders)),
        ],
      );
      addTearDown(container.dispose);

      container.listen(patientRemindersProvider('patient-1'), (_, _) {});

      final result = await container.read(
        patientDailyAdherenceProvider('patient-1').future,
      );
      expect(result, closeTo(66.67, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-005: patientDailyAdherence filters out reminders from other days
  // ---------------------------------------------------------------------------
  group('patientDailyAdherenceProvider — SC-CAR-005', () {
    test(
      'excludes yesterday reminders; returns 100.0 for 1 taken today',
      () async {
        final today = DateTime.now();
        final yesterday = today.subtract(const Duration(days: 1));

        final reminders = [
          // Today: taken
          _makeReminder(
            'r1',
            'med-1',
            DateTime(today.year, today.month, today.day, 8, 0),
            ReminderStatus.taken,
          ),
          // Yesterday: missed (should be excluded)
          _makeReminder(
            'r2',
            'med-1',
            DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 0),
            ReminderStatus.missed,
          ),
          _makeReminder(
            'r3',
            'med-1',
            DateTime(yesterday.year, yesterday.month, yesterday.day, 12, 0),
            ReminderStatus.missed,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            patientRemindersProvider(
              'patient-1',
            ).overrideWith((ref) => Stream.value(reminders)),
          ],
        );
        addTearDown(container.dispose);

        container.listen(patientRemindersProvider('patient-1'), (_, _) {});

        final result = await container.read(
          patientDailyAdherenceProvider('patient-1').future,
        );
        expect(result, equals(100.0));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-006: patientMedicationStatus maps medication + reminder to correct status/variant
  // ---------------------------------------------------------------------------
  group('patientMedicationStatusProvider — SC-CAR-006', () {
    test('returns correct status and variant for taken and missed', () async {
      final today = DateTime.now();
      final medA = _makeMed('med-a', 'Med A');
      final medB = _makeMed('med-b', 'Med B');

      final reminders = [
        _makeReminder(
          'r1',
          'med-a',
          DateTime(today.year, today.month, today.day, 8, 0),
          ReminderStatus.taken,
        ),
        _makeReminder(
          'r2',
          'med-b',
          DateTime(today.year, today.month, today.day, 8, 0),
          ReminderStatus.missed,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          patientMedicationsProvider(
            'patient-1',
          ).overrideWith((ref) => Stream.value([medA, medB])),
          patientRemindersProvider(
            'patient-1',
          ).overrideWith((ref) => Stream.value(reminders)),
        ],
      );
      addTearDown(container.dispose);

      container.listen(patientMedicationsProvider('patient-1'), (_, _) {});
      container.listen(patientRemindersProvider('patient-1'), (_, _) {});

      final result = await container.read(
        patientMedicationStatusProvider('patient-1').future,
      );
      expect(result, hasLength(2));

      final statusA = result.firstWhere((m) => m['name'] == 'Med A');
      expect(statusA['status'], equals('Taken'));
      expect(statusA['variant'], equals(MpBadgeVariant.taken));

      final statusB = result.firstWhere((m) => m['name'] == 'Med B');
      expect(statusB['status'], equals('Missed'));
      expect(statusB['variant'], equals(MpBadgeVariant.missed));
    });
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-007: patientMedicationStatus defaults to pending when no reminders
  // ---------------------------------------------------------------------------
  group('patientMedicationStatusProvider — SC-CAR-007', () {
    test(
      'defaults to pending variant when no today reminders for medication',
      () async {
        final medA = _makeMed('med-a', 'Med A');

        final container = ProviderContainer(
          overrides: [
            patientMedicationsProvider(
              'patient-1',
            ).overrideWith((ref) => Stream.value([medA])),
            patientRemindersProvider(
              'patient-1',
            ).overrideWith((ref) => Stream.value([])),
          ],
        );
        addTearDown(container.dispose);

        container.listen(patientMedicationsProvider('patient-1'), (_, __) {});
        container.listen(patientRemindersProvider('patient-1'), (_, __) {});

        final result = await container.read(
          patientMedicationStatusProvider('patient-1').future,
        );
        expect(result, hasLength(1));
        expect(result[0]['status'], equals(ReminderStatus.pending.label));
        expect(result[0]['variant'], equals(MpBadgeVariant.upcoming));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-008: patientMedicationStatus uses most recent reminder
  // ---------------------------------------------------------------------------
  group('patientMedicationStatusProvider — SC-CAR-008', () {
    test(
      'uses most recent reminder when multiple exist for same medication',
      () async {
        final today = DateTime.now();
        final medA = _makeMed('med-a', 'Med A');

        final reminders = [
          // Older: missed
          _makeReminder(
            'r1',
            'med-a',
            DateTime(today.year, today.month, today.day, 8, 0),
            ReminderStatus.missed,
          ),
          // More recent: taken
          _makeReminder(
            'r2',
            'med-a',
            DateTime(today.year, today.month, today.day, 12, 0),
            ReminderStatus.taken,
          ),
        ];

        final container = ProviderContainer(
          overrides: [
            patientMedicationsProvider(
              'patient-1',
            ).overrideWith((ref) => Stream.value([medA])),
            patientRemindersProvider(
              'patient-1',
            ).overrideWith((ref) => Stream.value(reminders)),
          ],
        );
        addTearDown(container.dispose);

        container.listen(patientMedicationsProvider('patient-1'), (_, __) {});
        container.listen(patientRemindersProvider('patient-1'), (_, __) {});

        final result = await container.read(
          patientMedicationStatusProvider('patient-1').future,
        );
        expect(result[0]['status'], equals('Taken'));
        expect(result[0]['variant'], equals(MpBadgeVariant.taken));
      },
    );
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-009: _reminderStatusToVariant maps all ReminderStatus values
  // ---------------------------------------------------------------------------
  group(
    '_reminderStatusToVariant — SC-CAR-009 (via patientMedicationStatus)',
    () {
      Future<MpBadgeVariant> variantFor(ReminderStatus status) async {
        final today = DateTime.now();
        final med = _makeMed('med-1', 'Med 1');
        final reminder = _makeReminder(
          'r1',
          'med-1',
          DateTime(today.year, today.month, today.day, 8, 0),
          status,
        );

        final container = ProviderContainer(
          overrides: [
            patientMedicationsProvider(
              'p',
            ).overrideWith((ref) => Stream.value([med])),
            patientRemindersProvider(
              'p',
            ).overrideWith((ref) => Stream.value([reminder])),
          ],
        );
        addTearDown(container.dispose);

        container.listen(patientMedicationsProvider('p'), (_, __) {});
        container.listen(patientRemindersProvider('p'), (_, __) {});

        final result = await container.read(
          patientMedicationStatusProvider('p').future,
        );
        return result[0]['variant'] as MpBadgeVariant;
      }

      test('taken -> MpBadgeVariant.taken', () async {
        expect(
          await variantFor(ReminderStatus.taken),
          equals(MpBadgeVariant.taken),
        );
      });

      test('missed -> MpBadgeVariant.missed', () async {
        expect(
          await variantFor(ReminderStatus.missed),
          equals(MpBadgeVariant.missed),
        );
      });

      test('snoozed -> MpBadgeVariant.snoozed', () async {
        expect(
          await variantFor(ReminderStatus.snoozed),
          equals(MpBadgeVariant.snoozed),
        );
      });

      test('skipped -> MpBadgeVariant.missed (same as missed)', () async {
        expect(
          await variantFor(ReminderStatus.skipped),
          equals(MpBadgeVariant.missed),
        );
      });

      test('pending -> MpBadgeVariant.upcoming', () async {
        expect(
          await variantFor(ReminderStatus.pending),
          equals(MpBadgeVariant.upcoming),
        );
      });
    },
  );

  // ---------------------------------------------------------------------------
  // SC-CAR-010: caregiverPatientsProvider yields empty list when user is null
  // ---------------------------------------------------------------------------
  group('caregiverPatientsProvider — SC-CAR-010', () {
    test('yields empty list when auth user is null', () async {
      final container = ProviderContainer(
        overrides: [
          // Override auth to return null user
          authStateProvider.overrideWith((ref) => Stream.value(null)),
          maxPatientsProvider.overrideWithValue(999),
        ],
      );
      addTearDown(container.dispose);

      container.listen(authStateProvider, (_, __) {});

      // Listen to the patients stream and collect emissions
      final emissions = <List<dynamic>>[];
      container.listen<AsyncValue<List<dynamic>>>(caregiverPatientsProvider, (
        _,
        next,
      ) {
        next.whenData((patients) => emissions.add(patients));
      }, fireImmediately: true);

      await Future<void>.delayed(Duration.zero);

      expect(emissions, isNotEmpty);
      // The first emitted value should be an empty list
      expect(emissions.first, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // SC-CAR-001 & SC-CAR-002: canAddPatient regression (already in existing file, repeat here)
  // ---------------------------------------------------------------------------
  group('canAddPatientProvider — regression', () {
    test('SC-CAR-001: returns true when 0 patients and max=1', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);
      container.listen(caregiverPatientsProvider, (_, __) {});

      expect(await container.read(canAddPatientProvider.future), isTrue);
    });

    test('SC-CAR-002: returns false when 1 patient and max=1', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'P1', linkedAt: null),
            ]),
          ),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);
      container.listen(caregiverPatientsProvider, (_, __) {});

      expect(await container.read(canAddPatientProvider.future), isFalse);
    });
  });
}
