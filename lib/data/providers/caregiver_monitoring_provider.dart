import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/data/services/firestore_service.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';

part 'caregiver_monitoring_provider.g.dart';

// Provider for FirestoreService
@riverpod
FirestoreService firestoreService(Ref ref) {
  return FirestoreService();
}

// Stream of patient's medications (real-time)
@riverpod
Stream<List<Medication>> patientMedications(Ref ref, String patientId) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.watchPatientMedications(patientId);
}

// Stream of patient's reminders (real-time)
@riverpod
Stream<List<Reminder>> patientReminders(Ref ref, String patientId) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.watchPatientReminders(patientId);
}

// Computed: patient daily adherence from reminders
@riverpod
Future<double> patientDailyAdherence(Ref ref, String patientId) async {
  final reminders = await ref.watch(patientRemindersProvider(patientId).future);
  final today = DateTime.now();
  final todayReminders = reminders.where((r) {
    return r.scheduledTime.year == today.year &&
        r.scheduledTime.month == today.month &&
        r.scheduledTime.day == today.day;
  }).toList();

  if (todayReminders.isEmpty) return 100.0;

  final taken = todayReminders.where((r) => r.status.name == 'taken').length;
  final total = todayReminders.length;
  return (taken / total) * 100;
}

// Stream of linked patients from Firestore
@riverpod
Stream<List<({String patientId, String patientName, DateTime? linkedAt})>>
caregiverPatients(Ref ref) async* {
  final user = ref.watch(authStateProvider).maybeWhen(
    data: (u) => u,
    orElse: () => null,
  );
  if (user == null) {
    yield [];
    return;
  }
  final firestore = ref.watch(firestoreServiceProvider);
  yield [];
  yield* firestore
      .watchLinkedPatients()
      .map(
        (docs) => docs.map((doc) {
          return (
            patientId: doc['patientId'] as String? ?? '',
            patientName: doc['patientName'] as String? ?? 'Patient',
            linkedAt: doc['linkedAt'] != null
                ? (doc['linkedAt'] as Timestamp).toDate()
                : null,
          );
        }).toList(),
      )
      .transform(
        StreamTransformer.fromHandlers(
          handleError: (error, stackTrace, sink) {
            // Graceful degradation: permission-denied means Firestore rules have
            // not been deployed yet. Treat as no linked patients so the
            // caregiver sees the connect-guide instead of an error screen.
            // TODO: revisit after `firebase deploy --only firestore:rules`
            if (error is FirebaseException &&
                error.code == 'permission-denied') {
              ErrorHandler.debugLog(
                error,
                stackTrace,
                'caregiverPatients: permission-denied — emitting empty list',
              );
              sink.add([]);
            } else {
              sink.addError(error, stackTrace);
            }
          },
        ),
      );
}

// Combines medications + reminders into PatientCard format
@riverpod
Future<List<Map<String, dynamic>>> patientMedicationStatus(
  Ref ref,
  String patientId,
) async {
  final medications = await ref.watch(
    patientMedicationsProvider(patientId).future,
  );
  final reminders = await ref.watch(patientRemindersProvider(patientId).future);

  final today = DateTime.now();
  final todayReminders = reminders
      .where(
        (r) =>
            r.scheduledTime.year == today.year &&
            r.scheduledTime.month == today.month &&
            r.scheduledTime.day == today.day,
      )
      .toList();

  return medications.map((med) {
    // Find today's reminder for this medication
    final medReminders = todayReminders
        .where((r) => r.medicationId == med.id)
        .toList();

    ReminderStatus status;
    if (medReminders.isEmpty) {
      status = ReminderStatus.pending;
    } else {
      // Use the most recent reminder's status
      medReminders.sort((a, b) => b.scheduledTime.compareTo(a.scheduledTime));
      status = medReminders.first.status;
    }

    return {
      'shape': med.shape,
      'color': med.color,
      'name': med.name,
      'status': status.label,
      'variant': _reminderStatusToVariant(status),
    };
  }).toList();
}

/// Check if caregiver can add another patient based on subscription tier
@riverpod
Future<bool> canAddPatient(Ref ref) async {
  final patients = await ref.watch(caregiverPatientsProvider.future);
  final maxPatients = ref.watch(maxPatientsProvider);
  return patients.length < maxPatients;
}

// Helper function to map ReminderStatus to MpBadgeVariant
MpBadgeVariant _reminderStatusToVariant(ReminderStatus status) {
  switch (status) {
    case ReminderStatus.taken:
      return MpBadgeVariant.taken;
    case ReminderStatus.missed:
      return MpBadgeVariant.missed;
    case ReminderStatus.snoozed:
      return MpBadgeVariant.snoozed;
    case ReminderStatus.skipped:
      return MpBadgeVariant.missed;
    case ReminderStatus.pending:
      return MpBadgeVariant.upcoming;
  }
}
