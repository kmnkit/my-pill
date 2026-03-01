import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/dialogs/mp_confirm_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpConfirmDialog', () {
    // -----------------------------------------------------------------------
    // Direct widget rendering tests
    // -----------------------------------------------------------------------

    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(
            title: 'Confirm Action',
            message: 'Are you sure?',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Confirm Action'), findsOneWidget);
    });

    testWidgets('renders message text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(
            title: 'Title',
            message: 'This is the message body.',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('This is the message body.'), findsOneWidget);
    });

    testWidgets('renders default confirm label when none provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'Title', message: 'Message'),
        ),
      );
      await tester.pumpAndSettle();

      // l10n default: 'Confirm'
      expect(find.text('Confirm'), findsOneWidget);
    });

    testWidgets('renders default cancel label when none provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'Title', message: 'Message'),
        ),
      );
      await tester.pumpAndSettle();

      // l10n default: 'Cancel'
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('renders custom confirm label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(
            title: 'Delete',
            message: 'Delete everything?',
            confirmLabel: 'Delete Everything',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete Everything'), findsOneWidget);
    });

    testWidgets('renders custom cancel label', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(
            title: 'Title',
            message: 'Message',
            cancelLabel: 'Go Back',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Go Back'), findsOneWidget);
    });

    testWidgets('confirm button uses primary variant by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'Title', message: 'Message'),
        ),
      );
      await tester.pumpAndSettle();

      // Find the MpButton with primary variant (ElevatedButton inside)
      final buttons = tester
          .widgetList<MpButton>(find.byType(MpButton))
          .toList();
      expect(buttons.any((b) => b.variant == MpButtonVariant.primary), isTrue);
    });

    testWidgets('confirm button uses destructive variant when isDestructive', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(
            title: 'Delete Account',
            message: 'This cannot be undone.',
            confirmLabel: 'Delete',
            isDestructive: true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester
          .widgetList<MpButton>(find.byType(MpButton))
          .toList();
      expect(
        buttons.any((b) => b.variant == MpButtonVariant.destructive),
        isTrue,
      );
    });

    testWidgets('cancel button uses text variant', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'Title', message: 'Message'),
        ),
      );
      await tester.pumpAndSettle();

      final buttons = tester
          .widgetList<MpButton>(find.byType(MpButton))
          .toList();
      expect(buttons.any((b) => b.variant == MpButtonVariant.text), isTrue);
    });

    testWidgets('dialog has rounded shape (Dialog widget present)', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'Title', message: 'Message'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // MpConfirmDialog.show() interaction tests
    // -----------------------------------------------------------------------

    testWidgets('show() displays dialog with title and message', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => MpConfirmDialog.show(
                context,
                title: 'Confirm This',
                message: 'Are you sure you want to do this?',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm This'), findsOneWidget);
      expect(find.text('Are you sure you want to do this?'), findsOneWidget);
    });

    testWidgets('tapping confirm button returns true via Navigator.pop', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await MpConfirmDialog.show(
                  context,
                  title: 'Confirm',
                  message: 'Proceed?',
                  confirmLabel: 'Yes',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('tapping cancel button returns false via Navigator.pop', (
      tester,
    ) async {
      bool? result;

      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () async {
                result = await MpConfirmDialog.show(
                  context,
                  title: 'Confirm',
                  message: 'Proceed?',
                  cancelLabel: 'No',
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('No'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('show() with isDestructive shows destructive button', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => MpConfirmDialog.show(
                context,
                title: 'Delete',
                message: 'Really delete?',
                confirmLabel: 'Delete',
                isDestructive: true,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      final buttons = tester
          .widgetList<MpButton>(find.byType(MpButton))
          .toList();
      expect(
        buttons.any((b) => b.variant == MpButtonVariant.destructive),
        isTrue,
      );
    });

    testWidgets('dialog is dismissed after tapping confirm', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => MpConfirmDialog.show(
                context,
                title: 'Confirm',
                message: 'Message',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsAtLeastNWidgets(1));

      await tester.tap(find.text('Confirm').last);
      await tester.pumpAndSettle();

      // Dialog dismissed – title text should no longer appear
      expect(find.text('Confirm'), findsNothing);
    });

    testWidgets('dialog is dismissed after tapping cancel', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => MpConfirmDialog.show(
                context,
                title: 'My Dialog Title',
                message: 'Message',
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('My Dialog Title'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('My Dialog Title'), findsNothing);
    });

    testWidgets('renders without error in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpConfirmDialog(title: 'タイトル', message: 'メッセージ'),
          locale: const Locale('ja'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('タイトル'), findsOneWidget);
      expect(find.text('メッセージ'), findsOneWidget);
    });
  });
}
