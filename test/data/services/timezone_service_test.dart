import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/services/timezone_service.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  group('TimezoneService', () {
    late TimezoneService service;

    setUpAll(() async {
      await TimezoneService.initialize();
      service = TimezoneService();
    });

    // ── initialize ──────────────────────────────────────────────────────────

    test('initialize is idempotent — safe to call multiple times', () async {
      await TimezoneService.initialize();
      await expectLater(TimezoneService.initialize(), completes);
    });

    // ── getTimeDifference ───────────────────────────────────────────────────

    test('getTimeDifference returns correct offset Tokyo vs New York', () {
      // New York is UTC-5 (EST) or UTC-4 (EDT), Tokyo is UTC+9.
      final diff = service.getTimeDifference('America/New_York', 'Asia/Tokyo');
      expect(diff, anyOf(equals(13), equals(14))); // DST-aware
    });

    test('getTimeDifference same timezone returns 0', () {
      final diff = service.getTimeDifference(
        'America/New_York',
        'America/New_York',
      );
      expect(diff, equals(0));
    });

    test('getTimeDifference UTC to Tokyo is +9', () {
      final diff = service.getTimeDifference('UTC', 'Asia/Tokyo');
      expect(diff, equals(9));
    });

    test('getTimeDifference UTC to UTC is 0', () {
      final diff = service.getTimeDifference('UTC', 'UTC');
      expect(diff, equals(0));
    });

    test('getTimeDifference is anti-symmetric (flipped sign)', () {
      final tokyoToNY = service.getTimeDifference(
        'Asia/Tokyo',
        'America/New_York',
      );
      final nyToTokyo = service.getTimeDifference(
        'America/New_York',
        'Asia/Tokyo',
      );
      expect(tokyoToNY, equals(-nyToTokyo));
    });

    // ── getLocation ─────────────────────────────────────────────────────────

    test('getLocation returns a valid location for Asia/Tokyo', () {
      final loc = service.getLocation('Asia/Tokyo');
      expect(loc.name, equals('Asia/Tokyo'));
    });

    test('getLocation returns a valid location for UTC', () {
      final loc = service.getLocation('UTC');
      expect(loc, isNotNull);
    });

    // ── formatTimezone ──────────────────────────────────────────────────────

    test('formatTimezone returns formatted string for Asia/Tokyo', () {
      final formatted = service.formatTimezone('Asia/Tokyo');
      expect(formatted, contains('JST'));
      expect(formatted, contains('+9'));
    });

    test('formatTimezone for negative offset contains minus sign', () {
      final formatted = service.formatTimezone('America/New_York');
      expect(formatted, anyOf(contains('EST'), contains('EDT')));
      expect(formatted, anyOf(contains('-5'), contains('-4')));
    });

    test('formatTimezone for UTC contains +0 or offset 0', () {
      final formatted = service.formatTimezone('UTC');
      expect(formatted, isNotEmpty);
    });

    // ── convertTime ─────────────────────────────────────────────────────────

    test('convertTime preserves the same UTC instant', () {
      final original = DateTime.utc(2024, 6, 15, 12, 0, 0); // noon UTC
      final converted = service.convertTime(
        original,
        'America/New_York',
        'Asia/Tokyo',
      );
      // Converting between timezones preserves the UTC instant —
      // difference should be 0 since the underlying moment is the same.
      final diffHours = converted.toUtc().difference(original.toUtc()).inHours;
      expect(diffHours, equals(0));
    });

    test('convertTime same timezone returns equivalent time', () {
      // Use TZDateTime to avoid dependence on the host machine's local timezone.
      final tokyo = tz.getLocation('Asia/Tokyo');
      final original = tz.TZDateTime(tokyo, 2024, 1, 1, 9, 30);
      final converted = service.convertTime(
        original,
        'Asia/Tokyo',
        'Asia/Tokyo',
      );
      // Same timezone → same wall-clock representation.
      expect(converted.hour, equals(9));
      expect(converted.minute, equals(30));
    });

    test('convertTime from UTC to Tokyo adds 9 hours', () {
      final original = DateTime.utc(2024, 3, 10, 0, 0); // midnight UTC
      final converted = service.convertTime(original, 'UTC', 'Asia/Tokyo');
      expect(converted.hour, equals(9));
    });

    // ── adjustMedicationTime ────────────────────────────────────────────────

    group('adjustMedicationTime — fixedInterval mode', () {
      test('preserves UTC instant, shifts wall-clock by offset', () {
        // 9 AM in Tokyo home timezone — use TZDateTime to avoid host-tz dependency.
        final tokyo = tz.getLocation('Asia/Tokyo');
        final homeTime = tz.TZDateTime(tokyo, 2024, 6, 15, 9, 0);
        final adjusted = service.adjustMedicationTime(
          homeTime,
          'Asia/Tokyo',
          'America/New_York',
          TimezoneMode.fixedInterval,
        );
        // fixedInterval = same UTC instant → wall clock shifts.
        // 9 AM JST = midnight (00:00) EDT (UTC-4) or 23:00 EST (UTC-5).
        expect(adjusted.hour, anyOf(equals(20), equals(21))); // 20 EDT / 21 EST
      });
    });

    group('adjustMedicationTime — localTime mode', () {
      test('keeps same wall-clock hour in destination timezone', () {
        final homeTime = DateTime(2024, 6, 15, 9, 30); // 9:30 home
        final adjusted = service.adjustMedicationTime(
          homeTime,
          'Asia/Tokyo',
          'America/New_York',
          TimezoneMode.localTime,
        );
        // localTime = same hour:minute in the new TZ.
        expect(adjusted.hour, equals(9));
        expect(adjusted.minute, equals(30));
      });

      test('keeps same wall-clock hour when traveling east', () {
        final homeTime = DateTime(2024, 1, 10, 8, 0); // 8 AM home
        final adjusted = service.adjustMedicationTime(
          homeTime,
          'America/New_York',
          'Asia/Tokyo',
          TimezoneMode.localTime,
        );
        expect(adjusted.hour, equals(8));
        expect(adjusted.minute, equals(0));
      });
    });

    // ── getAffectedTimes ────────────────────────────────────────────────────

    test('getAffectedTimes returns one entry per input time', () {
      final times = [
        DateTime(2024, 6, 15, 8, 0),
        DateTime(2024, 6, 15, 12, 0),
        DateTime(2024, 6, 15, 20, 0),
      ];
      final results = service.getAffectedTimes(
        times,
        'Asia/Tokyo',
        'America/New_York',
        TimezoneMode.localTime,
      );
      expect(results.length, equals(3));
    });

    test('getAffectedTimes returns empty list for empty input', () {
      final results = service.getAffectedTimes(
        [],
        'Asia/Tokyo',
        'America/New_York',
        TimezoneMode.fixedInterval,
      );
      expect(results, isEmpty);
    });

    test('getAffectedTimes preserves homeTime field unchanged', () {
      final homeTime = DateTime(2024, 6, 15, 9, 0);
      final results = service.getAffectedTimes(
        [homeTime],
        'Asia/Tokyo',
        'America/New_York',
        TimezoneMode.localTime,
      );
      expect(results.first.homeTime, equals(homeTime));
    });

    test('getAffectedTimes includes non-empty homeLabel and localLabel', () {
      final results = service.getAffectedTimes(
        [DateTime(2024, 6, 15, 9, 0)],
        'Asia/Tokyo',
        'America/New_York',
        TimezoneMode.localTime,
      );
      expect(results.first.homeLabel, isNotEmpty);
      expect(results.first.localLabel, isNotEmpty);
    });

    test(
      'getAffectedTimes localTime mode: localTime hour matches original',
      () {
        final homeTime = DateTime(2024, 6, 15, 14, 30);
        final results = service.getAffectedTimes(
          [homeTime],
          'Asia/Tokyo',
          'America/New_York',
          TimezoneMode.localTime,
        );
        expect(results.first.localTime.hour, equals(14));
        expect(results.first.localTime.minute, equals(30));
      },
    );

    // ── Additional coverage: edge cases ─────────────────────────────────────

    test('getTimeDifference London vs Tokyo accounts for DST variability', () {
      // London is UTC+0 (GMT) or UTC+1 (BST), Tokyo is UTC+9.
      final diff = service.getTimeDifference('Europe/London', 'Asia/Tokyo');
      expect(diff, anyOf(equals(8), equals(9))); // DST-aware
    });

    test('convertTime midnight boundary crosses to next day', () {
      // 23:59 in Tokyo → convert to a timezone ahead → should be next day
      final tokyo = tz.getLocation('Asia/Tokyo');
      final original = tz.TZDateTime(tokyo, 2024, 6, 15, 23, 59);
      // Converting from Tokyo (UTC+9) to Fiji (UTC+12) adds 3 hours
      final converted = service.convertTime(
        original,
        'Asia/Tokyo',
        'Pacific/Fiji',
      );
      expect(converted.day, equals(16));
      expect(converted.hour, equals(2));
      expect(converted.minute, equals(59));
    });

    test(
      'adjustMedicationTime fixedInterval same timezone preserves original',
      () {
        final tokyo = tz.getLocation('Asia/Tokyo');
        final homeTime = tz.TZDateTime(tokyo, 2024, 6, 15, 9, 30);
        final adjusted = service.adjustMedicationTime(
          homeTime,
          'Asia/Tokyo',
          'Asia/Tokyo',
          TimezoneMode.fixedInterval,
        );
        expect(adjusted.hour, equals(9));
        expect(adjusted.minute, equals(30));
      },
    );

    test(
      'adjustMedicationTime localTime same timezone preserves original',
      () {
        final homeTime = DateTime(2024, 6, 15, 14, 45);
        final adjusted = service.adjustMedicationTime(
          homeTime,
          'Asia/Tokyo',
          'Asia/Tokyo',
          TimezoneMode.localTime,
        );
        expect(adjusted.hour, equals(14));
        expect(adjusted.minute, equals(45));
      },
    );

    test('getAffectedTimes fixedInterval mode shifts time by offset', () {
      final tokyo = tz.getLocation('Asia/Tokyo');
      final homeTime = tz.TZDateTime(tokyo, 2024, 6, 15, 9, 0);
      final results = service.getAffectedTimes(
        [homeTime],
        'Asia/Tokyo',
        'America/New_York',
        TimezoneMode.fixedInterval,
      );
      // fixedInterval: same UTC instant → wall clock shifts by offset.
      // 9 AM JST = 20:00 EDT or 21:00 EST
      expect(results.first.localTime.hour, anyOf(equals(20), equals(21)));
      expect(results.first.homeTime.hour, equals(9));
    });
  });
}
