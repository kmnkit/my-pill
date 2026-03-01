// ignore_for_file: deprecated_member_use
import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kusuridoki/core/utils/sentry_scrubber.dart';

void main() {
  group('scrubPhiFromEvent', () {
    test('removes medication-related keys from extras', () {
      final event = SentryEvent(
        extra: const {
          'medicationName': 'Aspirin',
          'dosage': '100mg',
          'pillColor': 'red',
          'pillShape': 'round',
          'screen': 'home',
        },
      );

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.extra, isNot(contains('medicationName')));
      expect(result.extra, isNot(contains('dosage')));
      expect(result.extra, isNot(contains('pillColor')));
      expect(result.extra, isNot(contains('pillShape')));
      expect(result.extra!['screen'], 'home');
    });

    test('strips user PII keeping only id', () {
      final event = SentryEvent(
        user: SentryUser(
          id: 'firebase-uid-123',
          email: 'user@example.com',
          username: 'John Doe',
        ),
      );

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.user!.id, 'firebase-uid-123');
      expect(result.user!.email, isNull);
      expect(result.user!.username, isNull);
    });

    test('passes through event with no extras or user', () {
      final event = SentryEvent(message: SentryMessage('test'));

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.message!.formatted, 'test');
    });

    test('passes through event with empty extras', () {
      final event = SentryEvent(extra: const {});

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.extra, isEmpty);
    });

    test('preserves non-PHI extras while removing PHI keys', () {
      final event = SentryEvent(
        extra: const {
          'medicationName': 'secret',
          'errorCode': 'TIMEOUT',
          'retryCount': 3,
        },
      );

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.extra, isNot(contains('medicationName')));
      expect(result.extra!['errorCode'], 'TIMEOUT');
      expect(result.extra!['retryCount'], 3);
    });

    test('handles event with user id only (no PII to strip)', () {
      final event = SentryEvent(
        user: SentryUser(id: 'uid-only'),
      );

      final result = scrubPhiFromEvent(event, Hint());

      expect(result, isNotNull);
      expect(result!.user!.id, 'uid-only');
      expect(result.user!.email, isNull);
    });
  });
}
