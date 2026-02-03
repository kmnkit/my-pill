import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_pill/data/enums/apple_auth_error.dart';

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
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current user
  User? get currentUser => _auth.currentUser;

  // Anonymous sign-in (default on first launch)
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  // Email/password registration
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Email/password sign-in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    final googleAccount = await _googleSignIn.authenticate();
    final googleAuth = googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  // Apple Sign-In with proper error handling
  Future<UserCredential> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider();
      return await _auth.signInWithProvider(appleProvider);
    } on FirebaseAuthException catch (e) {
      throw AppleSignInException(
        error: AppleAuthError.fromCode(e.code),
        originalMessage: e.message,
      );
    }
  }

  // Link anonymous account to email/password
  Future<UserCredential> linkWithEmail(String email, String password) async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authenticated user to link');
    final credential = EmailAuthProvider.credential(email: email, password: password);
    return await user.linkWithCredential(credential);
  }

  // Link anonymous account to Google
  Future<UserCredential?> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authenticated user to link');
    final googleAccount = await _googleSignIn.authenticate();
    final googleAuth = googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return await user.linkWithCredential(credential);
  }

  // Link anonymous account to Apple with proper error handling
  Future<UserCredential> linkWithApple() async {
    final user = _auth.currentUser;
    if (user == null) throw StateError('No authenticated user to link');
    try {
      final appleProvider = AppleAuthProvider();
      return await user.linkWithProvider(appleProvider);
    } on FirebaseAuthException catch (e) {
      throw AppleSignInException(
        error: AppleAuthError.fromCode(e.code),
        originalMessage: e.message,
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Delete account
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  // Password reset
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// Check if an email is an Apple private relay email.
  /// Apple private relay emails end with @privaterelay.appleid.com
  static bool isPrivateRelayEmail(String? email) {
    if (email == null) return false;
    return email.toLowerCase().endsWith('@privaterelay.appleid.com');
  }
}
