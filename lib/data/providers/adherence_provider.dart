import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/adherence_service.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';

part 'adherence_provider.g.dart';

@riverpod
Future<double> overallAdherence(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final result = await service.getOverallAdherence();
  return result / 100.0; // Service returns 0-100, provider returns 0.0-1.0
}

@riverpod
Future<double> medicationAdherence(Ref ref, String medicationId) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final result = await service.getMedicationAdherence(medicationId);
  return result / 100.0;
}

@riverpod
Future<Map<String, double>> weeklyAdherence(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  return service.getWeeklyAdherence(); // Returns dayName -> percentage (0-100)
}

@riverpod
Future<List<({String id, String name, double percentage})>> medicationBreakdown(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final medicationsAsync = await ref.watch(medicationListProvider.future);
  return service.getMedicationBreakdown(medicationsAsync);
}

@riverpod
String adherenceRating(Ref ref, double percentage) {
  if (percentage >= 95) return 'Excellent';
  if (percentage >= 80) return 'Good';
  if (percentage >= 50) return 'Fair';
  return 'Poor';
}
