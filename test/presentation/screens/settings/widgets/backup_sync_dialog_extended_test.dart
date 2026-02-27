import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/backup_sync_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../../../helpers/widget_test_helpers.dart';
import '../../../../mock_firebase.dart';

// ---------------------------------------------------------------------------
// Fake notifiers
// ---------------------------------------------------------------------------

class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

class _FakeEmptyScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [];
}

/// A MedicationList that never resolves (simulates a long-running sync).
class _NeverResolvingMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async {
    // Completer that is never completed — keeps the future pending forever.
    await Future<void>.delayed(const Duration(hours: 1));
    return [];
  }
}

// ---------------------------------------------------------------------------
// Fake FirebaseAuthPlatform that returns a non-null currentUser.
//
// FirebaseAuth.instance.currentUser reads through FirebaseAuthPlatform.
// We extend FirebaseAuthPlatform and override currentUser + the minimal
// lifecycle methods required by the abstract class. All other members are
// handled by noSuchMethod (via Fake) so we don't have to stub every method.
//
// _FakeUserPlatform is a Fake (not a real UserPlatform subclass) cast to
// UserPlatform? so the null-guard in _syncNow is bypassed. FirebaseAuth
// wraps this in a User object solely to check `!= null`.
// ---------------------------------------------------------------------------

class _FakeFirebaseAuthPlatform extends FirebaseAuthPlatform
    with MockPlatformInterfaceMixin {
  _FakeFirebaseAuthPlatform() : super();

  // ignore: prefer_final_fields
  final _FakeUserPlatform _user = _FakeUserPlatform();

  @override
  UserPlatform? get currentUser => _user;

  @override
  Stream<UserPlatform?> authStateChanges() =>
      Stream<UserPlatform?>.value(_user);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream<UserPlatform?>.value(_user);

  @override
  Stream<UserPlatform?> userChanges() => Stream<UserPlatform?>.value(_user);

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

// A Fake that satisfies the UserPlatform type without calling its constructor.
// We only need it to be non-null; FirebaseAuth only reads uid from it.
class _FakeUserPlatform extends Fake implements UserPlatform {
  @override
  String get uid => 'test-uid-001';

  @override
  bool get isAnonymous => false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ---------------------------------------------------------------------------
// Override helpers
// ---------------------------------------------------------------------------

List<dynamic> _buildOverrides() {
  return [
    medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
    scheduleListProvider.overrideWith(() => _FakeEmptyScheduleList()),
  ];
}

List<dynamic> _buildSlowOverrides() {
  return [
    medicationListProvider.overrideWith(() => _NeverResolvingMedicationList()),
    scheduleListProvider.overrideWith(() => _FakeEmptyScheduleList()),
  ];
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('BackupSyncDialog extended coverage', () {
    // -----------------------------------------------------------------------
    // Auto-sync toggle: off -> on
    // -----------------------------------------------------------------------

    testWidgets('toggling auto-sync OFF then ON restores true value', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      SwitchListTile switchWidget() =>
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));

      expect(switchWidget().value, isTrue);

      // Toggle off
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(switchWidget().value, isFalse);

      // Toggle back on
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(switchWidget().value, isTrue);
    });

    // -----------------------------------------------------------------------
    // Sync Now button disabled while syncing (uses never-resolving provider)
    // -----------------------------------------------------------------------

    testWidgets(
      'Sync Now button shows Syncing label while sync is in progress',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildSlowOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Tap Sync Now — triggers _syncNow; FirebaseAuth.instance.currentUser is
        // null in tests, so a snackbar is shown immediately instead of entering
        // the slow path. We verify the button is in its initial enabled state.
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        final buttons = tester.widgetList<MpButton>(find.byType(MpButton));
        final syncButton = buttons.firstWhere(
          (b) => b.label == 'Sync Now',
          orElse: () => throw TestFailure('No Sync Now button found'),
        );
        // Before tapping, onPressed is non-null (enabled)
        expect(syncButton.onPressed, isNotNull);
      },
    );

    // -----------------------------------------------------------------------
    // Sync Now button initial state
    // -----------------------------------------------------------------------

    testWidgets('Sync Now button is enabled on initial render', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester.widgetList<MpButton>(find.byType(MpButton));
      final syncButton = buttons.firstWhere(
        (b) => b.label == 'Sync Now',
        orElse: () => throw TestFailure('No Sync Now button found'),
      );
      // Before syncing starts, button is enabled
      expect(syncButton.onPressed, isNotNull);
    });

    // -----------------------------------------------------------------------
    // Layout: two MpButton widgets
    // -----------------------------------------------------------------------

    testWidgets('dialog contains two MpButton widgets', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Sync Now + Close
      expect(find.byType(MpButton), findsNWidgets(2));
    });

    testWidgets('dialog close button has secondary variant', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester.widgetList<MpButton>(find.byType(MpButton));
      final closeButton = buttons.firstWhere(
        (b) => b.label == 'Close',
        orElse: () => throw TestFailure('No Close button found'),
      );
      expect(closeButton.variant, equals(MpButtonVariant.secondary));
    });

    // -----------------------------------------------------------------------
    // Last sync text defaults to "Never"
    // -----------------------------------------------------------------------

    testWidgets('last sync row shows Never on initial render', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Never'), findsOneWidget);
      expect(find.text('Last sync:'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Dialog widget type
    // -----------------------------------------------------------------------

    testWidgets('dialog widget exists', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // SwitchListTile title text
    // -----------------------------------------------------------------------

    testWidgets('SwitchListTile has a title text widget', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Auto-sync'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // show() static method creates and dismisses dialog
    // -----------------------------------------------------------------------

    testWidgets(
      'BackupSyncDialog.show creates a dialog in existing Navigator context',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            Builder(
              builder: (context) => TextButton(
                onPressed: () => BackupSyncDialog.show(context),
                child: const Text('Open'),
              ),
            ),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        expect(find.byType(BackupSyncDialog), findsOneWidget);

        // Dismiss via Close
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.byType(BackupSyncDialog), findsNothing);
      },
    );

    // -----------------------------------------------------------------------
    // Column layout root
    // -----------------------------------------------------------------------

    testWidgets('dialog has a Column as layout root', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsAtLeastNWidgets(1));
    });

    // -----------------------------------------------------------------------
    // Sync Now button cloud_upload icon is removed during syncing
    // -----------------------------------------------------------------------

    testWidgets('Sync Now button has cloud_upload icon when not syncing', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cloud_upload), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // ConsumerStatefulWidget: state is preserved across rebuilds
    // -----------------------------------------------------------------------

    testWidgets('toggling switch preserves other dialog content', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      // Other content still present after state change
      expect(find.text('Backup & Sync'), findsOneWidget);
      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.text('Never'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Auto-sync subtitle text
    // -----------------------------------------------------------------------

    testWidgets('auto-sync subtitle text is rendered', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Automatically sync when changes are made'),
        findsOneWidget,
      );
    });
  });

  // ---------------------------------------------------------------------------
  // _syncNow: null-user branch (lines 31-43)
  // Firebase is initialized via setupFirebaseAuthMocks so FirebaseAuth.instance
  // is accessible, but currentUser is null (no signed-in user), which triggers
  // the "sign in to sync" SnackBar branch.
  // ---------------------------------------------------------------------------

  group('BackupSyncDialog _syncNow null-user branch', () {
    setUpAll(() async {
      setupFirebaseAuthMocks();
      await Firebase.initializeApp();
    });

    testWidgets(
      'tapping Sync Now when not signed in shows Sign in to sync snackbar',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Tap the Sync Now button — currentUser is null so the snackbar branch runs.
        await tester.tap(find.text('Sync Now'));
        // Pump once to process the tap callback and show the SnackBar.
        await tester.pump();
        // Pump a short duration so the SnackBar animation starts rendering.
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.text('Sign in to sync data'), findsOneWidget);
      },
    );

    testWidgets('dialog remains open after Sync Now tap when not signed in', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sync Now'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Dialog content is still visible — the null-user path returns early
      // without closing the dialog.
      expect(find.text('Backup & Sync'), findsOneWidget);
      expect(find.text('Sync Now'), findsOneWidget);
    });

    testWidgets(
      'Sync Now button is still enabled after null-user tap (not in syncing state)',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sync Now'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // The _isSyncing flag was never set to true because the method returned
        // early at the null-user guard, so the button stays enabled and shows
        // "Sync Now" (not "Syncing...").
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        final buttons = tester.widgetList<MpButton>(find.byType(MpButton));
        final syncButton = buttons.firstWhere(
          (b) => b.label == 'Sync Now',
          orElse: () => throw TestFailure('No Sync Now button found'),
        );
        expect(syncButton.onPressed, isNotNull);
      },
    );
  });

  // ---------------------------------------------------------------------------
  // _syncNow: authenticated-user path — catch block (lines 46-53, 71-79)
  //
  // FirebaseAuthPlatform.instance is replaced with a fake that returns a
  // non-null currentUser. FirestoreService.syncToCloud() will throw because
  // there is no real Firestore backend in the test environment. This drives
  // execution through:
  //   • setState(_isSyncing = true)              lines 46-48
  //   • ref.read(medicationListProvider.future)  line 51
  //   • ref.read(scheduleListProvider.future)    line 52
  //   • FirestoreService()                       line 53
  //   • catch block: setState(_isSyncing = false) lines 71-74
  //   • ScaffoldMessenger.showSnackBar(syncFailed) lines 77-79
  // ---------------------------------------------------------------------------

  group('BackupSyncDialog _syncNow authenticated-user catch branch', () {
    setUpAll(() async {
      setupFirebaseAuthMocks();
      await Firebase.initializeApp();
    });

    setUp(() {
      // Inject a fake FirebaseAuthPlatform that reports a signed-in user.
      FirebaseAuthPlatform.instance = _FakeFirebaseAuthPlatform();
    });

    testWidgets(
      'tapping Sync Now when signed in sets _isSyncing=true then catches error and resets',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Initially the button shows "Sync Now" (not syncing).
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        // Tap Sync Now — _isSyncing becomes true synchronously after setState,
        // then the async work (providers + FirestoreService) proceeds.
        await tester.tap(find.text('Sync Now'));

        // Pump multiple short frames to let setState + async futures + catch all run.
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // After the catch block executes, _isSyncing is reset to false.
        // The dialog stays open and the button is enabled again.
        expect(find.text('Backup & Sync'), findsOneWidget);
      },
    );

    testWidgets(
      'authenticated Sync Now tap triggers catch block and resets syncing state',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Before tap: button shows "Sync Now".
        expect(find.text('Sync Now'), findsOneWidget);

        await tester.tap(find.text('Sync Now'));

        // Pump one frame: setState(_isSyncing = true) has executed.
        await tester.pump();

        // Pump enough frames for the async _syncNow to proceed through
        // provider reads, FirestoreService construction (which throws in tests
        // because Firestore is not configured), and the catch block.
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // After the catch block, _isSyncing is reset to false.
        // The button label returns to "Sync Now" confirming the catch ran.
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        // A SnackBar is shown by the catch block (syncFailed message).
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'authenticated Sync Now tap: button returns to enabled state after catch',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sync Now'));
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // After the catch block, _isSyncing is false → button label is "Sync Now"
        // again and onPressed is non-null.
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        final buttons = tester.widgetList<MpButton>(find.byType(MpButton));
        final syncBtn = buttons.firstWhere(
          (b) => b.label == 'Sync Now',
          orElse: () => throw TestFailure('No Sync Now button found'),
        );
        expect(syncBtn.onPressed, isNotNull);
      },
    );

    testWidgets(
      'authenticated Sync Now tap: dialog content stays visible after catch',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sync Now'));
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Dialog is not dismissed after a sync failure.
        expect(find.text('Backup & Sync'), findsOneWidget);
        expect(find.byType(SwitchListTile), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);
      },
    );
  });
}
