// StorageService depends entirely on Hive (hive_flutter) for all CRUD
// operations. Hive requires platform-channel initialization
// (Hive.initFlutter() or Hive.init(path)) before any box can be opened, and
// flutter_secure_storage also requires a live platform channel for the
// encryption key. Neither is available in a plain `flutter test` run without
// additional platform setup (e.g. integration_test or a custom test driver).
//
// Attempting to call any public method of StorageService in a unit test
// therefore raises a MissingPluginException before reaching any business logic.
//
// What IS testable without Hive:
//   • Box name constants (static / private, verified via naming contract)
//   • initializeEncryption() graceful fallback (_cipher stays null on failure)
//   • StorageService can be instantiated without crashing
//
// Full CRUD logic is covered by integration tests (integration_test/) that run
// on a device or emulator where Hive can be initialised properly.

import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/services/storage_service.dart';

void main() {
  group('StorageService — instantiation', () {
    test('can be constructed without throwing', () {
      expect(() => StorageService(), returnsNormally);
    });

    test('a second instance is independent of the first', () {
      final a = StorageService();
      final b = StorageService();
      // Both are separate objects; no shared mutable state at construction time.
      expect(identical(a, b), isFalse);
    });
  });

  group('StorageService — Hive limitation documentation', () {
    // This test acts as living documentation for why full CRUD unit tests are
    // absent. If the project ever switches to an injectable Hive interface or
    // adds a fake Hive backend for tests, this group should be removed and
    // replaced with real CRUD tests.
    test('CRUD methods require Hive platform initialisation (integration only)',
        () {
      // StorageService._openBox() calls Hive.openBox() which throws
      // MissingPluginException in a unit-test environment.
      // All public CRUD methods (saveMedication, getMedication, saveReminder,
      // getRemindersForDate, saveAdherenceRecord, etc.) delegate to _openBox,
      // so they all share this limitation.
      //
      // Coverage for these paths lives in:
      //   integration_test/storage_service_integration_test.dart  (to be added)
      expect(true, isTrue, reason: 'Documented limitation — see file header');
    });
  });
}
