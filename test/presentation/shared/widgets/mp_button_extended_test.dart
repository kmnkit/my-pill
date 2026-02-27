import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpButton extended', () {
    // -----------------------------------------------------------------------
    // isFullWidth
    // -----------------------------------------------------------------------

    testWidgets('primary variant fills width when isFullWidth is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(label: 'Full', onPressed: null, isFullWidth: true),
        ),
      );
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, equals(double.infinity));
    });

    testWidgets(
      'primary variant does not fill width when isFullWidth is false',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const MpButton(label: 'Small', onPressed: null, isFullWidth: false),
          ),
        );
        await tester.pumpAndSettle();

        final sizedBox = tester.widget<SizedBox>(
          find
              .ancestor(
                of: find.byType(ElevatedButton),
                matching: find.byType(SizedBox),
              )
              .first,
        );
        expect(sizedBox.width, isNull);
      },
    );

    // -----------------------------------------------------------------------
    // icon / iconWidget
    // -----------------------------------------------------------------------

    testWidgets('primary variant renders with icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(label: 'With Icon', onPressed: null, icon: Icons.add),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('primary variant renders with iconWidget', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'With Widget Icon',
            onPressed: null,
            iconWidget: const Icon(Icons.star, key: Key('star-icon')),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('star-icon')), findsOneWidget);
    });

    testWidgets('destructive variant renders with icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(
            label: 'Delete',
            onPressed: null,
            variant: MpButtonVariant.destructive,
            icon: Icons.delete,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('text variant renders with icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(
            label: 'Text With Icon',
            onPressed: null,
            variant: MpButtonVariant.text,
            icon: Icons.close,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('secondary variant renders with icon', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(
            label: 'Secondary Icon',
            onPressed: null,
            variant: MpButtonVariant.secondary,
            icon: Icons.edit,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Secondary Icon'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // Semantics
    // -----------------------------------------------------------------------

    testWidgets('primary variant has button semantics with correct label', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(label: 'Save Changes', onPressed: null),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Save Changes').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('destructive variant has button semantics', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Destroy',
            onPressed: () {},
            variant: MpButtonVariant.destructive,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Destroy').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('text variant has button semantics', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Cancel Action',
            onPressed: () {},
            variant: MpButtonVariant.text,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Cancel Action').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('secondary variant renders', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Secondary Action',
            onPressed: () {},
            variant: MpButtonVariant.secondary,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Secondary Action'), findsOneWidget);
    });

    testWidgets('disabled primary button has enabled=false semantics', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(label: 'Disabled', onPressed: null),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(
        find.bySemanticsLabel('Disabled').first,
      );
      expect(semantics.hasFlag(SemanticsFlag.isEnabled), isFalse);
    });

    // -----------------------------------------------------------------------
    // Callbacks
    // -----------------------------------------------------------------------

    testWidgets('destructive variant callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Confirm Delete',
            onPressed: () => tapped = true,
            variant: MpButtonVariant.destructive,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Confirm Delete'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('text variant callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Text Tap',
            onPressed: () => tapped = true,
            variant: MpButtonVariant.text,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Text Tap'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('secondary variant callback fires on tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Secondary Tap',
            onPressed: () => tapped = true,
            variant: MpButtonVariant.secondary,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Secondary Tap'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('disabled destructive button does not fire callback', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'No Tap',
            onPressed: null,
            variant: MpButtonVariant.destructive,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('No Tap'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    // -----------------------------------------------------------------------
    // Dark theme
    // -----------------------------------------------------------------------

    testWidgets('secondary variant renders in dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: MpButton(
              label: 'Dark Secondary',
              onPressed: () {},
              variant: MpButtonVariant.secondary,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dark Secondary'), findsOneWidget);
    });

    testWidgets('primary variant renders in dark theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: MpButton(label: 'Dark Primary', onPressed: () {}),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dark Primary'), findsOneWidget);
    });

    // -----------------------------------------------------------------------
    // isFullWidth on non-primary variants
    // -----------------------------------------------------------------------

    testWidgets('destructive variant with isFullWidth false', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(
            label: 'Narrow Destructive',
            onPressed: null,
            variant: MpButtonVariant.destructive,
            isFullWidth: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(ElevatedButton),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, isNull);
    });
  });
}
