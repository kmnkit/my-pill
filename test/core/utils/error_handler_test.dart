import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/core/utils/error_handler.dart';

void main() {
  group('ErrorHandler', () {
    group('getMessage', () {
      test('returns network message for SocketException', () {
        final message = ErrorHandler.getMessage(Exception('SocketException: Failed'));
        expect(message, 'No internet connection. Please check your network.');
      });

      test('returns network message for NetworkException', () {
        final message = ErrorHandler.getMessage(Exception('NetworkException'));
        expect(message, 'No internet connection. Please check your network.');
      });

      test('returns timeout message for TimeoutException', () {
        final message = ErrorHandler.getMessage(Exception('TimeoutException'));
        expect(message, 'Request timed out. Please try again.');
      });

      test('returns firebase message for FirebaseException', () {
        final message = ErrorHandler.getMessage(Exception('FirebaseException'));
        expect(message, 'Service temporarily unavailable. Your data is saved locally.');
      });

      test('returns permission message for permission-denied', () {
        final message = ErrorHandler.getMessage(Exception('permission-denied'));
        expect(message, "You don't have permission to perform this action.");
      });

      test('returns generic message for unknown error', () {
        final message = ErrorHandler.getMessage(Exception('something random'));
        expect(message, 'Something went wrong. Please try again.');
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
