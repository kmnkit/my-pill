import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/providers/auth_provider.dart';
import 'package:my_pill/data/services/auth_service.dart';

@GenerateMocks([AuthService])
import 'auth_provider_test.mocks.dart';

void main() {
  group('authServiceProvider', () {
    test('provider exists and has correct name', () {
      expect(authServiceProvider.name, 'authServiceProvider');
    });

    test('can be overridden with a mock', () {
      final mockService = MockAuthService();
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(authServiceProvider);
      expect(result, isA<AuthService>());
      expect(result, same(mockService));
    });
  });

  group('authStateProvider', () {
    test('provider exists and has correct name', () {
      expect(authStateProvider.name, 'authStateProvider');
    });

    test('emits values from authService.authStateChanges', () async {
      final mockService = MockAuthService();
      final controller = StreamController<User?>();
      addTearDown(controller.close);

      when(mockService.authStateChanges).thenAnswer((_) => controller.stream);

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      // Initially loading
      final initialState = container.read(authStateProvider);
      expect(initialState, isA<AsyncLoading<User?>>());
    });

    test('reports null user when stream emits null', () async {
      final mockService = MockAuthService();
      final controller = StreamController<User?>();
      addTearDown(controller.close);

      when(mockService.authStateChanges).thenAnswer((_) => controller.stream);

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      // Listen to trigger provider evaluation
      container.listen(authStateProvider, (_, __) {});

      controller.add(null);
      await container.pump();

      final state = container.read(authStateProvider);
      expect(state, isA<AsyncData<User?>>());
      expect(state.value, isNull);
    });

    test('watches authServiceProvider for changes', () {
      final mockService = MockAuthService();
      final controller = StreamController<User?>();
      addTearDown(controller.close);

      when(mockService.authStateChanges).thenAnswer((_) => controller.stream);

      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockService),
        ],
      );
      addTearDown(container.dispose);

      container.listen(authStateProvider, (_, __) {});
      container.read(authStateProvider);

      verify(mockService.authStateChanges).called(1);
    });
  });
}
