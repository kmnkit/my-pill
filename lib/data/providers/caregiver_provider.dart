import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/caregiver_link.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';

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

/// Check if user can add another caregiver based on subscription tier
@riverpod
Future<bool> canAddCaregiver(Ref ref) async {
  final caregivers = await ref.watch(caregiverLinksProvider.future);
  final maxCaregivers = ref.watch(maxCaregiversProvider);
  return caregivers.length < maxCaregivers;
}

/// Get the number of remaining caregiver slots
@riverpod
Future<int> remainingCaregiverSlots(Ref ref) async {
  final caregivers = await ref.watch(caregiverLinksProvider.future);
  final maxCaregivers = ref.watch(maxCaregiversProvider);
  return (maxCaregivers - caregivers.length).clamp(0, maxCaregivers);
}
