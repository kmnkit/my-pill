import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:my_pill/data/enums/apple_auth_error.dart';
import 'package:my_pill/data/services/cloud_functions_service.dart';

/// Custom exception for Apple Sign-In errors with structured error information.
class AppleSignInException implements Exception {
  const AppleSignInException({required this.error, this.originalMessage});

  /// The structured Apple auth error.
  final AppleAuthError error;

  /// The original error message from Firebase, if available.
  final String? originalMessage;

  @override
  String toString() => 'AppleSignInException: ${error.code}';
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Anonymous sign-in (default on first launch)
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Google Sign-In via Firebase OAuth provider
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleProvider = GoogleAuthProvider();
      return await _auth.signInWithProvider(googleProvider);
    } on FirebaseAuthException catch (e) {
      // User cancelled the sign-in flow
      if (e.code == 'web-context-canceled' ||
          e.code == 'popup-closed-by-user' ||
          e.code == 'canceled') {
        return null;
      }
      rethrow;
    }
  }

  // Apple Sign-In with proper error handling
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      return await _auth.signInWithProvider(appleProvider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled') return null;
      throw AppleSignInException(
        error: AppleAuthError.fromCode(e.code),
        originalMessage: e.message,
      );
    } on PlatformException catch (e) {
      throw AppleSignInException(
        error: AppleAuthError.unknown,
        originalMessage: e.message,
      );
    }
  }

  // Link anonymous account to Google
  Future<UserCredential?> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authenticated user to link');
    try {
      final googleProvider = GoogleAuthProvider();
      return await user.linkWithProvider(googleProvider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'web-context-canceled' ||
          e.code == 'popup-closed-by-user' ||
          e.code == 'canceled') {
        return null;
      }
      rethrow;
    }
  }

  // Link anonymous account to Apple with proper error handling
  Future<UserCredential?> linkWithApple() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authenticated user to link');
    try {
      final appleProvider = AppleAuthProvider();
      return await user.linkWithProvider(appleProvider);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'canceled') return null;
      throw AppleSignInException(
        error: AppleAuthError.fromCode(e.code),
        originalMessage: e.message,
      );
    } on PlatformException catch (e) {
      throw AppleSignInException(
        error: AppleAuthError.unknown,
        originalMessage: e.message,
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete account — delegates to Cloud Function for server-side full data cleanup
  Future<void> deleteAccount() async {
    await CloudFunctionsService().deleteAccount();
  }

  /// Check if an email is an Apple private relay email.
  /// Apple private relay emails end with @privaterelay.appleid.com
  static bool isPrivateRelayEmail(String? email) {
    if (email == null) return false;
    return email.toLowerCase().endsWith('@privaterelay.appleid.com');
  }
}
