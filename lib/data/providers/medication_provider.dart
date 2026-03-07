import 'dart:async' show unawaited;

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/core/utils/analytics_service.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/repositories/medication_repository.dart';

part 'medication_provider.g.dart';

@riverpod
class MedicationList extends _$MedicationList {
  @override
  Future<List<Medication>> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getAllMedications();
  }

  Future<void> addMedication(Medication medication) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveMedication(medication);
    unawaited(AnalyticsService.logMedicationAdded());
    if (!ref.mounted) return;
    await _refreshState();
  }

  Future<void> updateMedication(Medication medication) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveMedication(medication);
    unawaited(AnalyticsService.logMedicationEdited());
    if (!ref.mounted) return;
    await _refreshState();
  }

  Future<void> deleteMedication(String id) async {
    final storage = ref.read(storageServiceProvider);
    final repository = MedicationRepository(storage);
    await repository.deleteMedication(id);
    unawaited(AnalyticsService.logMedicationDeleted());
    if (!ref.mounted) return;
    await _refreshState();
    ref.invalidate(todayRemindersProvider);
    ref.invalidate(scheduleListProvider);
  }

  // Update state directly to avoid Riverpod pause-count assertion.
  Future<void> _refreshState() async {
    state = AsyncData(await ref.read(storageServiceProvider).getAllMedications());
  }
}

@riverpod
Future<Medication?> medication(Ref ref, String id) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getMedication(id);
}
