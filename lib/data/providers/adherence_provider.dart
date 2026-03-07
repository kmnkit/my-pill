import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/data/services/adherence_service.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';

part 'adherence_provider.g.dart';

@riverpod
Future<double?> overallAdherence(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final result = await service.getOverallAdherence();
  if (result == null) return null;
  return result / 100.0; // Service returns 0-100, provider returns 0.0-1.0
}

@riverpod
Future<double?> medicationAdherence(Ref ref, String medicationId) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final result = await service.getMedicationAdherence(medicationId);
  if (result == null) return null;
  return result / 100.0;
}

@riverpod
Future<Map<String, double?>> weeklyAdherence(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  return service
      .getWeeklyAdherence(); // Returns dayName -> percentage (0-100), null if no data
}

@riverpod
Future<List<({String id, String name, double? percentage, bool hasSchedule})>>
medicationBreakdown(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final medications = await storage.getAllMedications();
  final schedules = await ref.watch(scheduleListProvider.future);
  final medicationIdsWithSchedule =
      schedules.map((s) => s.medicationId).toSet();
  final breakdown = await service.getMedicationBreakdown(medications);
  return breakdown
      .map(
        (item) => (
          id: item.id,
          name: item.name,
          percentage: item.percentage,
          hasSchedule: medicationIdsWithSchedule.contains(item.id),
        ),
      )
      .toList();
}

@riverpod
Future<int> adherenceStreak(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  return service.getCurrentStreak();
}

@riverpod
Future<int?> weeklyTrend(Ref ref) async {
  final storage = ref.watch(storageServiceProvider);
  final service = AdherenceService(storage);
  final current = await service.getOverallAdherence(days: 7);
  final previous = await service.getPreviousWeekAdherence();
  if (current == null || previous == null) return null;
  return (current - previous).round();
}

@riverpod
String adherenceRating(Ref ref, double percentage) {
  if (percentage >= 95) return 'Excellent';
  if (percentage >= 80) return 'Good';
  if (percentage >= 50) return 'Fair';
  return 'Poor';
}

@riverpod
Future<List<AdherenceRecord>> medicationHistory(
  Ref ref,
  String medicationId,
) async {
  final storage = ref.watch(storageServiceProvider);
  final records = await storage.getAdherenceRecords(
    medicationId: medicationId,
    startDate: DateTime.now().subtract(const Duration(days: 30)),
    endDate: DateTime.now(),
  );
  // Sort by date descending (most recent first)
  records.sort((a, b) => b.date.compareTo(a.date));
  return records.take(10).toList(); // Last 10 records
}
