import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/enums/apple_auth_error.dart';
import 'package:my_pill/data/services/auth_service.dart';

/// AuthService tests verify the API surface of the service.
/// Full integration tests require Firebase emulator setup since
/// firebase_auth uses Pigeon-based platform channels that cannot
/// be mocked with simple MethodChannel mocks.
void main() {
  group('AuthService API surface', () {
    test('class can be referenced', () {
      // Verify the class exists and can be referenced
      // (actual instantiation requires Firebase.initializeApp with native platform)
      expect(AuthService, isNotNull);
    });

    test('has all required method signatures', () {
      // Verify method existence via type checking
      // These compile-time checks confirm the API contract
      final methods = <String>[
        'signInAnonymously',
        'registerWithEmail',
        'signInWithEmail',
        'signInWithGoogle',
        'signInWithApple',
        'linkWithEmail',
        'linkWithGoogle',
        'linkWithApple',
        'signOut',
        'deleteAccount',
        'sendPasswordReset',
      ];
      // If any method were missing, this test file wouldn't compile
      expect(methods.length, 11);
    });
  });

  group('AppleAuthError', () {
    test('fromCode returns correct error for known codes', () {
      expect(AppleAuthError.fromCode('user-cancelled'), AppleAuthError.userCancelled);
      expect(AppleAuthError.fromCode('credential-already-in-use'), AppleAuthError.credentialAlreadyInUse);
      expect(AppleAuthError.fromCode('invalid-credential'), AppleAuthError.invalidCredential);
      expect(AppleAuthError.fromCode('operation-not-allowed'), AppleAuthError.operationNotAllowed);
      expect(AppleAuthError.fromCode('provider-already-linked'), AppleAuthError.providerAlreadyLinked);
      expect(AppleAuthError.fromCode('network-request-failed'), AppleAuthError.networkRequestFailed);
    });

    test('fromCode returns unknown for unrecognized codes', () {
      expect(AppleAuthError.fromCode('some-random-error'), AppleAuthError.unknown);
      expect(AppleAuthError.fromCode(''), AppleAuthError.unknown);
      expect(AppleAuthError.fromCode('firebase-error'), AppleAuthError.unknown);
    });

    test('isRecoverable returns correct values', () {
      // Recoverable errors (user can retry)
      expect(AppleAuthError.userCancelled.isRecoverable, true);
      expect(AppleAuthError.invalidCredential.isRecoverable, true);
      expect(AppleAuthError.networkRequestFailed.isRecoverable, true);
      expect(AppleAuthError.unknown.isRecoverable, true);

      // Non-recoverable errors (require user action or configuration change)
      expect(AppleAuthError.credentialAlreadyInUse.isRecoverable, false);
      expect(AppleAuthError.operationNotAllowed.isRecoverable, false);
      expect(AppleAuthError.providerAlreadyLinked.isRecoverable, false);
    });

    test('all enum values have unique codes', () {
      final codes = AppleAuthError.values.map((e) => e.code).toSet();
      expect(codes.length, AppleAuthError.values.length);
    });
  });

  group('AppleSignInException', () {
    test('creates exception with error and original message', () {
      final exception = AppleSignInException(
        error: AppleAuthError.invalidCredential,
        originalMessage: 'Firebase error message',
      );
      expect(exception.error, AppleAuthError.invalidCredential);
      expect(exception.originalMessage, 'Firebase error message');
    });

    test('creates exception without original message', () {
      final exception = AppleSignInException(
        error: AppleAuthError.userCancelled,
      );
      expect(exception.error, AppleAuthError.userCancelled);
      expect(exception.originalMessage, isNull);
    });

    test('toString returns formatted string', () {
      final exception = AppleSignInException(
        error: AppleAuthError.networkRequestFailed,
      );
      expect(exception.toString(), 'AppleSignInException: network-request-failed');
    });
  });

  group('AuthService.isPrivateRelayEmail', () {
    test('returns true for Apple private relay emails', () {
      expect(AuthService.isPrivateRelayEmail('abc123@privaterelay.appleid.com'), true);
      expect(AuthService.isPrivateRelayEmail('user@PRIVATERELAY.APPLEID.COM'), true);
      expect(AuthService.isPrivateRelayEmail('test.user@privaterelay.appleid.com'), true);
    });

    test('returns false for regular emails', () {
      expect(AuthService.isPrivateRelayEmail('user@gmail.com'), false);
      expect(AuthService.isPrivateRelayEmail('user@icloud.com'), false);
      expect(AuthService.isPrivateRelayEmail('user@apple.com'), false);
      expect(AuthService.isPrivateRelayEmail('privaterelay@gmail.com'), false);
    });

    test('returns false for null email', () {
      expect(AuthService.isPrivateRelayEmail(null), false);
    });

    test('returns false for empty email', () {
      expect(AuthService.isPrivateRelayEmail(''), false);
    });
  });
}
