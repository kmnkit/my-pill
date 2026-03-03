import 'package:riverpod_annotation/riverpod_annotation.dart';
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
    if (!ref.mounted) return;
    await _refreshState();
  }

  Future<void> updateMedication(Medication medication) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveMedication(medication);
    if (!ref.mounted) return;
    await _refreshState();
  }

  Future<void> deleteMedication(String id) async {
    final storage = ref.read(storageServiceProvider);
    final repository = MedicationRepository(storage);
    await repository.deleteMedication(id);
    if (!ref.mounted) return;
    await _refreshState();
    ref.invalidate(todayRemindersProvider);
    ref.invalidate(scheduleListProvider);
  }

  // Update state directly instead of invalidateSelf() to avoid triggering
  // runOnDispose on the .future proxy subscription held by downstream
  // providers (e.g. medicationBreakdownProvider), which causes a Riverpod
  // internal pause-count assertion (pausedActiveSubscriptionCount mismatch).
  Future<void> _refreshState() async {
    state = AsyncData(await ref.read(storageServiceProvider).getAllMedications());
  }
}

@riverpod
Future<Medication?> medication(Ref ref, String id) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getMedication(id);
}
