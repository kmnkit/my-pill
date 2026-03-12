import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/subscription_provider.dart';
import 'package:kusuridoki/data/services/firestore_service.dart';

// ---------------------------------------------------------------------------
// Test helpers
// ---------------------------------------------------------------------------

class _MockUser extends Fake implements User {
  @override
  String get uid => 'test-uid';
}

class _FakeFirestoreService extends Fake implements FirestoreService {
  final Stream<List<Map<String, dynamic>>> _stream;
  _FakeFirestoreService(this._stream);

  @override
  Stream<List<Map<String, dynamic>>> watchLinkedPatients() => _stream;
}

void main() {
  group('canAddPatientProvider', () {
    test('returns true when 0 patients and max=1 (free tier)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      // Listen before reading stream provider (CLAUDE.md gotcha)
      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isTrue);
    });

    test('returns false when 1 patient and max=1 (free tier limit reached)',
        () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'Patient 1', linkedAt: null),
            ]),
          ),
          maxPatientsProvider.overrideWithValue(1),
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isFalse);
    });

    test('returns true when 1 patient and max=999 (premium)', () async {
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'Patient 1', linkedAt: null),
            ]),
          ),
          maxPatientsProvider.overrideWithValue(999),
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isTrue);
    });

    test('returns false when stub service limits to 1 patient', () async {
      // kPremiumEnabled = true → maxPatientsProvider returns 1 (stub)
      // 2 patients already linked → canAddPatient is false
      final container = ProviderContainer(
        overrides: [
          caregiverPatientsProvider.overrideWith(
            (ref) => Stream.value([
              (patientId: 'p1', patientName: 'P1', linkedAt: null),
              (patientId: 'p2', patientName: 'P2', linkedAt: null),
            ]),
          ),
          // Use real maxPatientsProvider (kPremiumEnabled=true → 1)
        ],
      );
      addTearDown(container.dispose);

      container.listen(caregiverPatientsProvider, (_, __) {});

      final canAdd = await container.read(canAddPatientProvider.future);
      expect(canAdd, isFalse);
    });
  });

  group('caregiverPatientsProvider - error handling', () {
    /// Build a container where auth is resolved immediately and the Firestore
    /// stream is controlled by the provided [StreamController].
    ProviderContainer makeContainer(
      StreamController<List<Map<String, dynamic>>> controller,
    ) {
      return ProviderContainer(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream.value(_MockUser())),
          firestoreServiceProvider.overrideWith(
            (ref) => _FakeFirestoreService(controller.stream),
          ),
        ],
      );
    }

    /// Runs several event-loop ticks to let Riverpod process async state.
    Future<void> drain() async {
      for (var i = 0; i < 8; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    test('permission-denied emits empty list (graceful degradation)', () async {
      final controller = StreamController<List<Map<String, dynamic>>>();
      final container = makeContainer(controller);
      addTearDown(container.dispose);
      addTearDown(controller.close);

      // Activate the provider and wait for auth to resolve + provider to
      // start listening to the Firestore stream.
      container.listen(caregiverPatientsProvider, (_, _) {});
      await drain();

      // Emit the permission-denied error — the transform swallows it and
      // emits an empty list instead.
      controller.addError(
        FirebaseException(plugin: 'cloud_firestore', code: 'permission-denied'),
      );
      await drain();

      final state = container.read(caregiverPatientsProvider);
      expect(state, isA<AsyncData>());
      expect(state.value, isEmpty);
    });

    test('other Firestore error propagates as AsyncError', () async {
      final controller = StreamController<List<Map<String, dynamic>>>();
      final container = makeContainer(controller);
      addTearDown(container.dispose);
      addTearDown(controller.close);

      // Collect ALL state transitions: Riverpod v3 auto-restarts the stream
      // provider after its async* generator terminates with error, so the
      // AsyncError state is brief before transitioning to AsyncLoading again.
      final states = <AsyncValue>[];
      container.listen(
        caregiverPatientsProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      await drain(); // let auth resolve + provider start listening

      controller.addError(
        FirebaseException(plugin: 'cloud_firestore', code: 'unavailable'),
      );
      await drain(); // let error propagate through transform

      // Riverpod v3 may skip the AsyncError state and transition directly to
      // AsyncLoading(error: ...) as it auto-restarts the stream. Check that
      // the error was carried in any emitted state.
      expect(
        states.any((s) => s.error != null),
        isTrue,
        reason: 'expected error in state transitions: $states',
      );
    });

    test('non-Firebase error propagates as AsyncError', () async {
      final controller = StreamController<List<Map<String, dynamic>>>();
      final container = makeContainer(controller);
      addTearDown(container.dispose);
      addTearDown(controller.close);

      final states = <AsyncValue>[];
      container.listen(
        caregiverPatientsProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      await drain();

      controller.addError(Exception('unexpected network failure'));
      await drain();

      expect(
        states.any((s) => s.error != null),
        isTrue,
        reason: 'expected error in state transitions: $states',
      );
    });
  });
}
