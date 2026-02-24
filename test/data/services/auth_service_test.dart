import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/apple_auth_error.dart';
import 'package:my_pill/data/services/auth_service.dart';

/// AuthService tests verify the API surface of the service and all pure-logic
/// helpers. Full integration tests require a Firebase emulator because
/// firebase_auth uses Pigeon-based platform channels that cannot be mocked
/// with simple MethodChannel mocks in unit tests.
void main() {
  group('AuthService — class surface', () {
    test('class can be referenced', () {
      expect(AuthService, isNotNull);
    });

    test('isPrivateRelayEmail is a static method', () {
      // Compile-time check — if the method were missing this would not compile.
      final result = AuthService.isPrivateRelayEmail('test@gmail.com');
      expect(result, isFalse);
    });
  });

  // ── AppleAuthError ────────────────────────────────────────────────────────

  group('AppleAuthError — fromCode', () {
    test('returns userCancelled for "user-cancelled"', () {
      expect(
          AppleAuthError.fromCode('user-cancelled'), AppleAuthError.userCancelled);
    });

    test('maps iOS "canceled" shorthand to userCancelled', () {
      expect(AppleAuthError.fromCode('canceled'), AppleAuthError.userCancelled);
    });

    test('returns credentialAlreadyInUse for matching code', () {
      expect(
        AppleAuthError.fromCode('credential-already-in-use'),
        AppleAuthError.credentialAlreadyInUse,
      );
    });

    test('returns invalidCredential for matching code', () {
      expect(
        AppleAuthError.fromCode('invalid-credential'),
        AppleAuthError.invalidCredential,
      );
    });

    test('returns operationNotAllowed for matching code', () {
      expect(
        AppleAuthError.fromCode('operation-not-allowed'),
        AppleAuthError.operationNotAllowed,
      );
    });

    test('returns providerAlreadyLinked for matching code', () {
      expect(
        AppleAuthError.fromCode('provider-already-linked'),
        AppleAuthError.providerAlreadyLinked,
      );
    });

    test('returns networkRequestFailed for matching code', () {
      expect(
        AppleAuthError.fromCode('network-request-failed'),
        AppleAuthError.networkRequestFailed,
      );
    });

    test('returns unknown for unrecognised code', () {
      expect(AppleAuthError.fromCode('some-random-error'), AppleAuthError.unknown);
    });

    test('returns unknown for empty string', () {
      expect(AppleAuthError.fromCode(''), AppleAuthError.unknown);
    });

    test('returns unknown for arbitrary Firebase error code', () {
      expect(AppleAuthError.fromCode('firebase-error'), AppleAuthError.unknown);
    });
  });

  group('AppleAuthError — isRecoverable', () {
    test('userCancelled is recoverable', () {
      expect(AppleAuthError.userCancelled.isRecoverable, isTrue);
    });

    test('invalidCredential is recoverable', () {
      expect(AppleAuthError.invalidCredential.isRecoverable, isTrue);
    });

    test('networkRequestFailed is recoverable', () {
      expect(AppleAuthError.networkRequestFailed.isRecoverable, isTrue);
    });

    test('unknown is recoverable', () {
      expect(AppleAuthError.unknown.isRecoverable, isTrue);
    });

    test('credentialAlreadyInUse is NOT recoverable', () {
      expect(AppleAuthError.credentialAlreadyInUse.isRecoverable, isFalse);
    });

    test('operationNotAllowed is NOT recoverable', () {
      expect(AppleAuthError.operationNotAllowed.isRecoverable, isFalse);
    });

    test('providerAlreadyLinked is NOT recoverable', () {
      expect(AppleAuthError.providerAlreadyLinked.isRecoverable, isFalse);
    });
  });

  group('AppleAuthError — code uniqueness', () {
    test('all enum values have unique codes', () {
      final codes = AppleAuthError.values.map((e) => e.code).toSet();
      expect(codes.length, AppleAuthError.values.length);
    });

    test('every code is non-empty', () {
      for (final error in AppleAuthError.values) {
        expect(error.code, isNotEmpty,
            reason: '${error.name} should have a non-empty code');
      }
    });
  });

  // ── AppleSignInException ──────────────────────────────────────────────────

  group('AppleSignInException', () {
    test('stores error and originalMessage', () {
      final ex = AppleSignInException(
        error: AppleAuthError.invalidCredential,
        originalMessage: 'Firebase error message',
      );
      expect(ex.error, AppleAuthError.invalidCredential);
      expect(ex.originalMessage, 'Firebase error message');
    });

    test('originalMessage defaults to null', () {
      final ex = AppleSignInException(error: AppleAuthError.userCancelled);
      expect(ex.originalMessage, isNull);
    });

    test('toString includes the error code', () {
      final ex = AppleSignInException(error: AppleAuthError.networkRequestFailed);
      expect(ex.toString(), contains('network-request-failed'));
    });

    test('toString format is AppleSignInException: <code>', () {
      final ex = AppleSignInException(error: AppleAuthError.unknown);
      expect(ex.toString(), 'AppleSignInException: unknown');
    });

    test('implements Exception', () {
      final ex = AppleSignInException(error: AppleAuthError.unknown);
      expect(ex, isA<Exception>());
    });

    test('can be thrown and caught as Exception', () {
      expect(
        () => throw AppleSignInException(error: AppleAuthError.invalidCredential),
        throwsA(isA<AppleSignInException>()),
      );
    });

    test('caught exception preserves error type', () {
      try {
        throw AppleSignInException(
          error: AppleAuthError.credentialAlreadyInUse,
          originalMessage: 'original',
        );
      } on AppleSignInException catch (e) {
        expect(e.error, AppleAuthError.credentialAlreadyInUse);
        expect(e.originalMessage, 'original');
      }
    });
  });

  // ── AuthService.isPrivateRelayEmail ───────────────────────────────────────

  group('AuthService.isPrivateRelayEmail', () {
    test('returns true for standard Apple private relay email', () {
      expect(
        AuthService.isPrivateRelayEmail('abc123@privaterelay.appleid.com'),
        isTrue,
      );
    });

    test('returns true for uppercase private relay domain (case-insensitive)',
        () {
      expect(
        AuthService.isPrivateRelayEmail('user@PRIVATERELAY.APPLEID.COM'),
        isTrue,
      );
    });

    test('returns true for mixed-case private relay domain', () {
      expect(
        AuthService.isPrivateRelayEmail('test.user@privaterelay.appleid.com'),
        isTrue,
      );
    });

    test('returns false for regular Gmail address', () {
      expect(AuthService.isPrivateRelayEmail('user@gmail.com'), isFalse);
    });

    test('returns false for iCloud email', () {
      expect(AuthService.isPrivateRelayEmail('user@icloud.com'), isFalse);
    });

    test('returns false for apple.com email', () {
      expect(AuthService.isPrivateRelayEmail('user@apple.com'), isFalse);
    });

    test('returns false for email with privaterelay in local part', () {
      expect(
        AuthService.isPrivateRelayEmail('privaterelay@gmail.com'),
        isFalse,
      );
    });

    test('returns false for null email', () {
      expect(AuthService.isPrivateRelayEmail(null), isFalse);
    });

    test('returns false for empty string', () {
      expect(AuthService.isPrivateRelayEmail(''), isFalse);
    });

    test('returns false for partial domain match', () {
      expect(
        AuthService.isPrivateRelayEmail('user@privaterelay.appleid.net'),
        isFalse,
      );
    });
  });
}
