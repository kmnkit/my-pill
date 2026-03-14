import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

enum ErrorCode {
  network,
  timeout,
  serviceUnavailable,
  permissionDenied,
  generic,
}

abstract final class ErrorHandler {
  /// Log error details in debug mode only.
  static void debugLog(Object error, StackTrace? stackTrace, String context) {
    if (kDebugMode) {
      debugPrint('[ERROR] $context: $error');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
  }

  /// Report error to Crashlytics in release mode, or log in debug mode.
  ///
  /// Errors classified as [ErrorCode.permissionDenied] are not reported
  /// (user-initiated action, not a bug).
  static void captureException(
    Object error,
    StackTrace? stackTrace,
    String context,
  ) {
    debugLog(error, stackTrace, context);

    if (kDebugMode) return;

    if (getErrorCode(error) == ErrorCode.permissionDenied) return;

    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: context,
    );
  }

  /// Classify error into an [ErrorCode] for l10n-friendly handling.
  static ErrorCode getErrorCode(Object error) {
    final message = error.toString();

    if (message.contains('SocketException') ||
        message.contains('NetworkException')) {
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
