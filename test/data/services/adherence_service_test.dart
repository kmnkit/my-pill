import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/adherence_service.dart';
import 'package:my_pill/data/services/storage_service.dart';

void main() {
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
