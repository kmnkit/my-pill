// ignore_for_file: depend_on_referenced_packages
// FirestoreService unit tests.
//
// Scope: auth-guard behaviour (section 1.3) and the unauthenticated
// watchLinkedPatients stream path (FSSVC-EDGE-002).
//
// Blocked scenarios — require fake_cloud_firestore (not in pubspec.yaml)
// or constructor-injected FirebaseFirestore:
//   FSSVC-HAPPY-001  saveMedication — doc written at users/{uid}/medications/{id}
//   FSSVC-HAPPY-002  getAdherenceRecords with date range — 3 of 5 records
//   FSSVC-HAPPY-003  getAdherenceRecords no args — all records
//   FSSVC-EDGE-001   syncToCloud — batch.set × 5, commit × 1
//
// Resolution path: add fake_cloud_firestore to dev_dependencies OR refactor
// FirestoreService to accept FirebaseFirestore via constructor injection.
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/services/firestore_service.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../mock_firebase.dart';

// ---------------------------------------------------------------------------
// Fake FirebaseAuthPlatform — returns currentUser = null (unauthenticated).
//
// Using FirebaseAuthPlatform.instance = _FakeAuthPlatform() bypasses the
// Pigeon channel setup (registerIdTokenListener / registerAuthStateListener)
// that would otherwise throw PlatformException in unit tests.
// ---------------------------------------------------------------------------

class _FakeAuthPlatform extends FirebaseAuthPlatform
    with MockPlatformInterfaceMixin {
  _FakeAuthPlatform() : super();

  @override
  UserPlatform? get currentUser => null;

  @override
  Stream<UserPlatform?> authStateChanges() =>
      Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> userChanges() => Stream<UserPlatform?>.value(null);

  @override
  FirebaseAuthPlatform delegateFor({
    required FirebaseApp app,
    Persistence? persistence,
  }) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    PigeonUserDetails? currentUser,
    String? languageCode,
  }) => this;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    setupFirebaseAuthMocks();
  });

  // ── Unauthenticated — auth guard (FSSVC-ERROR-001 / SEC-AUTH-001) ─────────
  //
  // FirestoreService._userDoc throws StateError('No authenticated user')
  // when FirebaseAuth.instance.currentUser == null.
  // _FakeAuthPlatform.currentUser returns null without touching Pigeon
  // channels, so tests are fully isolated from platform infrastructure.

  group('unauthenticated', () {
    late FirestoreService svc;

    setUp(() {
      FirebaseAuthPlatform.instance = _FakeAuthPlatform();
      svc = FirestoreService();
    });

    // FSSVC-ERROR-001 / SEC-AUTH-001
    test('getAllMedications throws StateError', () async {
      await expectLater(
        () => svc.getAllMedications(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'No authenticated user',
          ),
        ),
      );
    });

    // FSSVC-ERROR-001 / SEC-AUTH-001
    test('saveMedication throws StateError', () async {
      await expectLater(
        () => svc.saveMedication(_fakeMedication()),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'No authenticated user',
          ),
        ),
      );
    });

    // FSSVC-ERROR-001 / SEC-AUTH-001
    test('getAdherenceRecords throws StateError', () async {
      await expectLater(
        () => svc.getAdherenceRecords(),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'No authenticated user',
          ),
        ),
      );
    });

    test('deleteMedication throws StateError', () async {
      await expectLater(
        () => svc.deleteMedication('any-id'),
        throwsA(isA<StateError>()),
      );
    });

    test('saveSchedule throws StateError', () async {
      await expectLater(
        () => svc.saveSchedule(_fakeSchedule()),
        throwsA(isA<StateError>()),
      );
    });

    test('getAllSchedules throws StateError', () async {
      await expectLater(
        () => svc.getAllSchedules(),
        throwsA(isA<StateError>()),
      );
    });

    // syncToCloud calls _db.batch() before iterating — with a non-empty
    // medications list it calls _medicationsCol which triggers _userDoc → throws.
    test('syncToCloud throws StateError when medications list is non-empty',
        () async {
      await expectLater(
        () => svc.syncToCloud([_fakeMedication()], []),
        throwsA(isA<StateError>()),
      );
    });

    // syncToCloud with both lists empty skips _userDoc entirely (no loop
    // body executes), so it does NOT throw — document this as known behaviour.
    test('syncToCloud with empty lists does not throw (no auth guard hit)', () {
      // _db.batch() + batch.commit() execute without touching _userDoc.
      // This is an architectural gap: the empty-list path is unauthenticated.
      expect(() => svc.syncToCloud([], []), returnsNormally);
    });

    test('getUserProfile throws StateError', () async {
      await expectLater(
        () => svc.getUserProfile(),
        throwsA(isA<StateError>()),
      );
    });

    test('watchMedications throws StateError', () {
      expect(
        () => svc.watchMedications(),
        throwsA(isA<StateError>()),
      );
    });

    test('watchSchedules throws StateError', () {
      expect(
        () => svc.watchSchedules(),
        throwsA(isA<StateError>()),
      );
    });

    // FSSVC-EDGE-002
    // watchLinkedPatients checks _userId (== null) before touching Firestore.
    // Returns Stream.value([]) — pure Dart logic, no Firestore call made.
    test('watchLinkedPatients emits empty list when not signed in', () async {
      final result = await svc.watchLinkedPatients().first;
      expect(result, isEmpty);
    });
  });
}

// ---------------------------------------------------------------------------
// Test fixtures
// ---------------------------------------------------------------------------

Medication _fakeMedication() {
  return Medication(
    id: 'med-001',
    name: 'Test Medication',
    dosage: 100,
    dosageUnit: DosageUnit.mg,
    createdAt: DateTime(2026, 3, 1),
  );
}

Schedule _fakeSchedule() {
  return Schedule(
    id: 'sched-001',
    medicationId: 'med-001',
    type: ScheduleType.daily,
  );
}
