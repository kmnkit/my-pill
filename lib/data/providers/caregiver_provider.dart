import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/caregiver_link.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';

part 'caregiver_provider.g.dart';

@riverpod
class CaregiverLinks extends _$CaregiverLinks {
  @override
  Future<List<CaregiverLink>> build() async {
    final storage = ref.watch(storageServiceProvider);
    return storage.getAllCaregiverLinks();
  }

  Future<void> addLink(CaregiverLink link) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveCaregiverLink(link);
    ref.invalidateSelf();
  }

  Future<void> removeLink(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteCaregiverLink(id);
    ref.invalidateSelf();
  }
}
