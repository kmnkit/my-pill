/// Error codes specific to Apple Sign-In with Firebase Auth.
enum AppleAuthError {
  /// User cancelled the sign-in flow.
  userCancelled(code: 'user-cancelled', isRecoverable: true),

  /// The Apple credential is already linked to a different Firebase account.
  credentialAlreadyInUse(code: 'credential-already-in-use', isRecoverable: false),

  /// The credential is invalid or expired.
  invalidCredential(code: 'invalid-credential', isRecoverable: true),

  /// Apple Sign-In is not enabled in Firebase console.
  operationNotAllowed(code: 'operation-not-allowed', isRecoverable: false),

  /// An Apple account is already linked to this Firebase user.
  providerAlreadyLinked(code: 'provider-already-linked', isRecoverable: false),

  /// Network request failed.
  networkRequestFailed(code: 'network-request-failed', isRecoverable: true),

  /// Unknown error occurred.
  unknown(code: 'unknown', isRecoverable: true);

  const AppleAuthError({required this.code, required this.isRecoverable});

  /// The Firebase error code associated with this error.
  final String code;

  /// Whether the user can retry the operation.
  final bool isRecoverable;

  /// Parse a Firebase error code to get the corresponding AppleAuthError.
  static AppleAuthError fromCode(String code) {
    return AppleAuthError.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AppleAuthError.unknown,
    );
  }
}
