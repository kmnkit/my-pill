import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/services/storage_service.dart';

class AdherenceService {
  final StorageService _storage;

  AdherenceService(this._storage);

  /// Calculate daily adherence for a date: taken / (taken + missed) * 100
  Future<double> getDailyAdherence(DateTime date) async {
    final records = await _storage.getAdherenceRecords(
      startDate: date,
      endDate: date,
    );

    // Filter to just taken and missed (exclude skipped from calculation)
    final taken = records.where((r) => r.status == ReminderStatus.taken).length;
    final missed = records.where((r) => r.status == ReminderStatus.missed).length;

    final total = taken + missed;

    // Return 100 if no records (no doses scheduled = perfect adherence)
    if (total == 0) return 100.0;

    return (taken / total) * 100;
  }

  /// Calculate overall adherence for all medications
  Future<double> getOverallAdherence({int days = 30}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    final records = await _storage.getAdherenceRecords(
      startDate: startDate,
      endDate: endDate,
    );

    // Filter to just taken and missed (exclude skipped from calculation)
    final taken = records.where((r) => r.status == ReminderStatus.taken).length;
    final missed = records.where((r) => r.status == ReminderStatus.missed).length;

    final total = taken + missed;

    // Return 100 if no records
    if (total == 0) return 100.0;

    return (taken / total) * 100;
  }

  /// Calculate per-medication adherence
  Future<double> getMedicationAdherence(
    String medicationId, {
    int days = 30,
  }) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    final records = await _storage.getAdherenceRecords(
      medicationId: medicationId,
      startDate: startDate,
      endDate: endDate,
    );

    // Filter to just taken and missed (exclude skipped from calculation)
    final taken = records.where((r) => r.status == ReminderStatus.taken).length;
    final missed = records.where((r) => r.status == ReminderStatus.missed).length;

    final total = taken + missed;

    // Return 100 if no records
    if (total == 0) return 100.0;

    return (taken / total) * 100;
  }

  /// Calculate weekly adherence: returns map of day label -> percentage for last 7 days
  Future<Map<String, double>> getWeeklyAdherence() async {
    final result = <String, double>{};
    final now = DateTime.now();
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final adherence = await getDailyAdherence(date);
      result[dayNames[date.weekday - 1]] = adherence;
    }
    return result;
  }

  /// Per-medication breakdown: returns list of (medicationId, medicationName, percentage)
  Future<List<({String id, String name, double percentage})>>
      getMedicationBreakdown(
    List<Medication> medications, {
    int days = 7,
  }) async {
    final result = <({String id, String name, double percentage})>[];

    for (final medication in medications) {
      final percentage = await getMedicationAdherence(
        medication.id,
        days: days,
      );

      result.add((
        id: medication.id,
        name: medication.name,
        percentage: percentage,
      ));
    }

    // Sort by percentage descending
    result.sort((a, b) => b.percentage.compareTo(a.percentage));

    return result;
  }

  /// Rating system based on adherence percentage
  String getAdherenceRating(double percentage) {
    if (percentage >= 95) return 'Excellent';
    if (percentage >= 80) return 'Good';
    if (percentage >= 50) return 'Fair';
    return 'Poor';
  }
}
