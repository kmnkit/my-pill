import 'package:flutter/material.dart';
import 'package:my_pill/data/enums/apple_auth_error.dart';
import 'package:my_pill/l10n/app_localizations.dart';

/// Extension to provide localized error messages for Apple Sign-In errors.
extension AppleAuthErrorMessages on AppleAuthError {
  /// Get a user-friendly localized message for this error.
  String getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AppleAuthError.userCancelled:
        return l10n.appleSignInCancelled;
      case AppleAuthError.credentialAlreadyInUse:
        return l10n.appleCredentialAlreadyInUse;
      case AppleAuthError.invalidCredential:
        return l10n.appleInvalidCredential;
      case AppleAuthError.operationNotAllowed:
        return l10n.appleOperationNotAllowed;
      case AppleAuthError.providerAlreadyLinked:
        return l10n.appleProviderAlreadyLinked;
      case AppleAuthError.networkRequestFailed:
        return l10n.appleNetworkError;
      case AppleAuthError.unknown:
        return l10n.appleSignInUnknownError;
    }
  }

  /// Whether to show a snackbar for this error.
  /// User cancellation is intentional and doesn't need a snackbar.
  bool get shouldShowSnackbar => this != AppleAuthError.userCancelled;
}
