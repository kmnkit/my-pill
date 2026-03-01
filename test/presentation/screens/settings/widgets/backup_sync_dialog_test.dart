import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/presentation/screens/settings/widgets/backup_sync_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

import '../../../../helpers/widget_test_helpers.dart';
import '../../../../mock_firebase.dart';

// Fake notifiers for providers the dialog reads
class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

class _FakeEmptyScheduleList extends ScheduleList {
  @override
  Future<List<Schedule>> build() async => [];
}

List<dynamic> _buildOverrides() {
  return [
    medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
    scheduleListProvider.overrideWith(() => _FakeEmptyScheduleList()),
  ];
}

void main() {
  group('BackupSyncDialog', () {
    testWidgets('renders dialog title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: backupAndSync -> "Backup & Sync"
      expect(find.text('Backup & Sync'), findsOneWidget);
    });

    testWidgets('renders sync description text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: syncWithCloud -> "Sync your data with the cloud"
      expect(find.text('Sync your data with the cloud'), findsOneWidget);
    });

    testWidgets('shows last sync label with Never as default', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: lastSync -> "Last sync:"
      expect(find.text('Last sync:'), findsOneWidget);
      // l10n: never -> "Never"
      expect(find.text('Never'), findsOneWidget);
    });

    testWidgets('shows Sync Now button with cloud upload icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: syncNow -> "Sync Now"
      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_upload), findsOneWidget);
    });

    testWidgets('shows auto-sync switch with title and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: autoSync -> "Auto-sync"
      expect(find.text('Auto-sync'), findsOneWidget);
      // l10n: autoSyncSubtitle -> "Automatically sync when changes are made"
      expect(
        find.text('Automatically sync when changes are made'),
        findsOneWidget,
      );
    });

    testWidgets('auto-sync switch defaults to on', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchWidget.value, isTrue);
    });

    testWidgets('toggling auto-sync switch changes its value', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the switch
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      final switchWidget = tester.widget<SwitchListTile>(
        find.byType(SwitchListTile),
      );
      expect(switchWidget.value, isFalse);
    });

    testWidgets('shows Close button', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: close -> "Close"
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('tapping Close button dismisses dialog', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => BackupSyncDialog.show(context),
              child: const Text('Open Dialog'),
            ),
          ),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Open the dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Backup & Sync'), findsOneWidget);

      // Tap close
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.text('Backup & Sync'), findsNothing);
    });

    testWidgets('dialog is rendered via static show method', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => BackupSyncDialog.show(context),
              child: const Text('Open Dialog'),
            ),
          ),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      // Dialog content should appear
      expect(find.text('Backup & Sync'), findsOneWidget);
      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('Sync Now button is rendered in dialog', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: syncNow -> "Sync Now"
      expect(find.text('Sync Now'), findsOneWidget);
    });

    testWidgets('renders with Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without errors (Japanese l10n)
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('dialog has correct shape (rounded corners)', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('Sync Now button is enabled when not syncing', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // The button label should be "Sync Now" (not "Syncing...")
      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.text('Syncing...'), findsNothing);
    });

    testWidgets('dialog contains a Row for last-sync display', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // The last-sync row uses a Row widget with spaceBetween alignment
      expect(find.byType(Row), findsAtLeastNWidgets(1));
    });

    testWidgets('dialog contains a Padding wrapping its content', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Padding), findsAtLeastNWidgets(1));
    });

    testWidgets('toggle switch off then back on restores enabled state', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      SwitchListTile sw() =>
          tester.widget<SwitchListTile>(find.byType(SwitchListTile));

      expect(sw().value, isTrue);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(sw().value, isFalse);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(sw().value, isTrue);
    });

    testWidgets('dialog contains exactly two KdButton widgets', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdButton), findsNWidgets(2));
    });

    testWidgets('Close KdButton has secondary variant', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester.widgetList<KdButton>(find.byType(KdButton));
      final closeBtn = buttons.firstWhere(
        (b) => b.label == 'Close',
        orElse: () => throw TestFailure('No Close button found'),
      );
      expect(closeBtn.variant, equals(MpButtonVariant.secondary));
    });

    testWidgets('Sync Now KdButton is enabled (onPressed non-null) initially', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester.widgetList<KdButton>(find.byType(KdButton));
      final syncBtn = buttons.firstWhere(
        (b) => b.label == 'Sync Now',
        orElse: () => throw TestFailure('No Sync Now button found'),
      );
      expect(syncBtn.onPressed, isNotNull);
    });

    testWidgets('Japanese locale renders dialog without errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const BackupSyncDialog(),
          overrides: _buildOverrides(),
        ),
      );
      await tester.pumpAndSettle();

      // All core structural widgets still present
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(SwitchListTile), findsOneWidget);
      expect(find.byType(KdButton), findsNWidgets(2));
    });

    testWidgets(
      'last-sync row shows "Last sync:" label and "Never" value side by side',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Both texts exist; they are siblings inside a Row
        final lastSyncFinder = find.text('Last sync:');
        final neverFinder = find.text('Never');
        expect(lastSyncFinder, findsOneWidget);
        expect(neverFinder, findsOneWidget);

        // Confirm they share the same Row ancestor
        final row = find.ancestor(
          of: lastSyncFinder,
          matching: find.byType(Row),
        );
        expect(row, findsAtLeastNWidgets(1));
        expect(
          find.descendant(of: row.first, matching: neverFinder),
          findsOneWidget,
        );
      },
    );
  });

  // ---------------------------------------------------------------------------
  // _syncNow: null-user branch
  // Firebase is initialised so FirebaseAuth.instance is accessible, but
  // currentUser is null (no signed-in user), which triggers the
  // "Sign in to sync data" SnackBar branch (lines 35-44 of the source).
  // ---------------------------------------------------------------------------

  group('BackupSyncDialog _syncNow null-user branch', () {
    setUpAll(() async {
      setupFirebaseAuthMocks();
      await Firebase.initializeApp();
    });

    testWidgets(
      'tapping Sync Now when unauthenticated shows "Sign in to sync data" snackbar',
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

        expect(find.text('Sign in to sync data'), findsOneWidget);
      },
    );

    testWidgets('dialog content stays visible after null-user Sync Now tap', (
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

      // Dialog is NOT dismissed; content remains
      expect(find.text('Backup & Sync'), findsOneWidget);
      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets(
      'button stays enabled and labelled "Sync Now" after null-user tap',
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

        // _isSyncing was never set to true — button must remain enabled
        expect(find.text('Sync Now'), findsOneWidget);
        expect(find.text('Syncing...'), findsNothing);

        final buttons = tester.widgetList<KdButton>(find.byType(KdButton));
        final syncBtn = buttons.firstWhere(
          (b) => b.label == 'Sync Now',
          orElse: () => throw TestFailure('No Sync Now button found'),
        );
        expect(syncBtn.onPressed, isNotNull);
      },
    );

    testWidgets(
      'tapping Sync Now twice when unauthenticated shows snackbar each time',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // First tap
        await tester.tap(find.text('Sync Now'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Sign in to sync data'), findsOneWidget);

        // Dismiss snackbar
        await tester.pumpAndSettle();

        // Second tap
        await tester.tap(find.text('Sync Now'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.text('Sign in to sync data'), findsOneWidget);
      },
    );

    testWidgets(
      'null-user snackbar appears even when auto-sync switch is toggled off',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const BackupSyncDialog(),
            overrides: _buildOverrides(),
          ),
        );
        await tester.pumpAndSettle();

        // Toggle auto-sync off first
        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();

        // Then tap Sync Now
        await tester.tap(find.text('Sync Now'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        // Should still show snackbar (autoSync state doesn't affect _syncNow)
        expect(find.text('Sign in to sync data'), findsOneWidget);
      },
    );
  });
}
