import 'package:firebase_auth/firebase_auth.dart';

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

  // Email/password registration
  Future<UserCredential> registerWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // Email/password sign-in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Google Sign-In (placeholder - needs google_sign_in package setup)
  Future<UserCredential?> signInWithGoogle() async {
    // TODO: Implement with google_sign_in package
    // For now, throw unimplemented
    throw UnimplementedError('Google Sign-In not yet configured');
  }

  // Apple Sign-In
  Future<UserCredential> signInWithApple() async {
    final appleProvider = AppleAuthProvider();
    return await _auth.signInWithProvider(appleProvider);
  }

  // Link anonymous account to email/password
  Future<UserCredential> linkWithEmail(String email, String password) async {
    final credential = EmailAuthProvider.credential(email: email, password: password);
    return await _auth.currentUser!.linkWithCredential(credential);
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
}
