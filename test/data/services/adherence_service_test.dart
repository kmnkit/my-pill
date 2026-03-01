import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/services/adherence_service.dart';
import 'package:kusuridoki/data/services/storage_service.dart';

/// Stub that captures the dates passed to getAdherenceRecords
/// and returns a fixed list of records.
class _CapturingStorageService extends StorageService {
  DateTime? capturedStartDate;
  DateTime? capturedEndDate;
  List<AdherenceRecord> recordsToReturn = [];

  @override
  Future<List<AdherenceRecord>> getAdherenceRecords({
    String? medicationId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    capturedStartDate = startDate;
    capturedEndDate = endDate;
    return recordsToReturn;
  }
}

void main() {
  group('AdherenceService date normalization', () {
    late _CapturingStorageService fakeStorage;
    late AdherenceService service;

    setUp(() {
      fakeStorage = _CapturingStorageService();
      service = AdherenceService(fakeStorage);
    });

    test('getDailyAdherence normalizes date to midnight', () async {
      // A date with a non-zero time component (simulates DateTime.now())
      final dateWithTime = DateTime(2026, 3, 1, 20, 35, 42);
      await service.getDailyAdherence(dateWithTime);

      expect(fakeStorage.capturedStartDate, isNotNull);
      expect(fakeStorage.capturedEndDate, isNotNull);
      expect(fakeStorage.capturedStartDate, equals(DateTime(2026, 3, 1)));
      expect(fakeStorage.capturedEndDate, equals(DateTime(2026, 3, 1)));
    });

    test('getOverallAdherence normalizes endDate to midnight', () async {
      await service.getOverallAdherence(days: 7);

      // endDate must be today at midnight (no time component)
      final today = DateTime.now();
      final expectedEnd = DateTime(today.year, today.month, today.day);
      expect(fakeStorage.capturedEndDate, equals(expectedEnd));
    });

    test('getMedicationAdherence normalizes endDate to midnight', () async {
      await service.getMedicationAdherence('med-1', days: 7);

      final today = DateTime.now();
      final expectedEnd = DateTime(today.year, today.month, today.day);
      expect(fakeStorage.capturedEndDate, equals(expectedEnd));
    });
  });

  group('AdherenceService', () {
    test('getAdherenceRating returns correct rating for percentages', () {
      final service = AdherenceService(StorageService());

      expect(service.getAdherenceRating(100), equals('Excellent'));
      expect(service.getAdherenceRating(95), equals('Excellent'));
      expect(service.getAdherenceRating(94), equals('Good'));
      expect(service.getAdherenceRating(90), equals('Good'));
      expect(service.getAdherenceRating(80), equals('Good'));
      expect(service.getAdherenceRating(79), equals('Fair'));
      expect(service.getAdherenceRating(70), equals('Fair'));
      expect(service.getAdherenceRating(50), equals('Fair'));
      expect(service.getAdherenceRating(49), equals('Poor'));
      expect(service.getAdherenceRating(30), equals('Poor'));
      expect(service.getAdherenceRating(0), equals('Poor'));
    });

    test('getAdherenceRating edge cases', () {
      final service = AdherenceService(StorageService());

      // Test exact boundaries
      expect(service.getAdherenceRating(95.0), equals('Excellent'));
      expect(service.getAdherenceRating(94.9), equals('Good'));
      expect(service.getAdherenceRating(80.0), equals('Good'));
      expect(service.getAdherenceRating(79.9), equals('Fair'));
      expect(service.getAdherenceRating(50.0), equals('Fair'));
      expect(service.getAdherenceRating(49.9), equals('Poor'));
    });
  });
}
