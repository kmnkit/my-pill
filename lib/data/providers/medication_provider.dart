import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';

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
    ref.invalidateSelf();
  }

  Future<void> updateMedication(Medication medication) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveMedication(medication);
    ref.invalidateSelf();
  }

  Future<void> deleteMedication(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteMedication(id);
    ref.invalidateSelf();
  }
}

@riverpod
Future<Medication?> medication(Ref ref, String id) async {
  final storage = ref.watch(storageServiceProvider);
  return storage.getMedication(id);
}
