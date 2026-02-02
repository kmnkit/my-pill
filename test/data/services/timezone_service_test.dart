import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/timezone_service.dart';

void main() {
  group('TimezoneService', () {
    late TimezoneService service;

    setUpAll(() async {
      await TimezoneService.initialize();
      service = TimezoneService();
    });

    test('getTimeDifference returns correct offset', () {
      // New York is UTC-5 (EST) or UTC-4 (EDT), Tokyo is UTC+9
      // Difference is 14 hours (EST) or 13 hours (EDT)
      final diff = service.getTimeDifference('America/New_York', 'Asia/Tokyo');
      expect(diff, anyOf(equals(13), equals(14))); // Account for DST
    });

    test('getTimeDifference same timezone returns 0', () {
      final diff = service.getTimeDifference('America/New_York', 'America/New_York');
      expect(diff, equals(0));
    });

    test('formatTimezone returns formatted string', () {
      final formatted = service.formatTimezone('Asia/Tokyo');
      expect(formatted, contains('JST'));
      expect(formatted, contains('+9'));
    });

    test('formatTimezone for negative offset', () {
      final formatted = service.formatTimezone('America/New_York');
      // Should contain timezone abbreviation and negative offset
      expect(formatted, anyOf(contains('EST'), contains('EDT')));
      expect(formatted, anyOf(contains('-5'), contains('-4'))); // EST or EDT
    });

    test('getTimeDifference with UTC', () {
      final diff = service.getTimeDifference('UTC', 'Asia/Tokyo');
      expect(diff, equals(9));
    });
  });
}
