import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';

part 'caregiver_provider.g.dart';

/// Real-time stream of caregiver links from Firestore.
/// Replaces the previous Hive-backed AsyncNotifierProvider so that
/// links created by Cloud Functions are reflected immediately.
@riverpod
Stream<List<CaregiverLink>> caregiverLinks(Ref ref) {
  final firestore = ref.watch(firestoreServiceProvider);
  return firestore.watchCaregiverLinks();
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
