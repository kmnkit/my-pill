import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_pill/data/services/auth_service.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@riverpod
Stream<User?> authState(Ref ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges;
}
