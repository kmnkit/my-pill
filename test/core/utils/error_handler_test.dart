import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/utils/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    group('getErrorCode', () {
      test('returns network for SocketException', () {
        final code = ErrorHandler.getErrorCode(Exception('SocketException: Failed'));
        expect(code, ErrorCode.network);
      });

      test('returns network for NetworkException', () {
        final code = ErrorHandler.getErrorCode(Exception('NetworkException'));
        expect(code, ErrorCode.network);
      });

      test('returns timeout for TimeoutException', () {
        final code = ErrorHandler.getErrorCode(Exception('TimeoutException'));
        expect(code, ErrorCode.timeout);
      });

      test('returns serviceUnavailable for FirebaseException', () {
        final code = ErrorHandler.getErrorCode(Exception('FirebaseException'));
        expect(code, ErrorCode.serviceUnavailable);
      });

      test('returns permissionDenied for permission-denied', () {
        final code = ErrorHandler.getErrorCode(Exception('permission-denied'));
        expect(code, ErrorCode.permissionDenied);
      });

      test('returns generic for unknown error', () {
        final code = ErrorHandler.getErrorCode(Exception('something random'));
        expect(code, ErrorCode.generic);
      });
    });

    group('debugLog', () {
      test('does not throw when called with error and stackTrace', () {
        expect(
          () => ErrorHandler.debugLog(
            Exception('test error'),
            StackTrace.current,
            'testContext',
          ),
          returnsNormally,
        );
      });

      test('does not throw when called with null stackTrace', () {
        expect(
          () => ErrorHandler.debugLog(
            Exception('test error'),
            null,
            'testContext',
          ),
          returnsNormally,
        );
      });
    });
  });
}
