import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/services/firestore_service.dart';

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
