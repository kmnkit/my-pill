import 'package:flutter/foundation.dart';

enum ErrorCode {
  network,
  timeout,
  serviceUnavailable,
  permissionDenied,
  generic,
}

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

  // Classify error into an ErrorCode for l10n-friendly handling
  static ErrorCode getErrorCode(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') || message.contains('NetworkException')) {
      return ErrorCode.network;
    }
    if (message.contains('TimeoutException')) {
      return ErrorCode.timeout;
    }
    if (message.contains('FirebaseException')) {
      return ErrorCode.serviceUnavailable;
    }
    if (message.contains('permission-denied')) {
      return ErrorCode.permissionDenied;
    }

    return ErrorCode.generic;
  }
}
