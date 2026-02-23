import 'package:flutter/foundation.dart';

abstract final class ErrorHandler {
  // Log error details in debug mode only
  static void debugLog(Object error, StackTrace? stackTrace, String context) {
    if (kDebugMode) {
      debugPrint('[ERROR] $context: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  // User-friendly error messages
  static String getMessage(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') || message.contains('NetworkException')) {
      return 'No internet connection. Please check your network.';
    }
    if (message.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    }
    if (message.contains('FirebaseException')) {
      return 'Service temporarily unavailable. Your data is saved locally.';
    }
    if (message.contains('permission-denied')) {
      return 'You don\'t have permission to perform this action.';
    }

    return 'Something went wrong. Please try again.';
  }
}
