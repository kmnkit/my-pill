import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const MpButton(label: 'Save', onPressed: null)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('onPressed callback fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(label: 'Tap me', onPressed: () => tapped = true),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tap me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('disabled state when onPressed is null', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpButton(label: 'Disabled', onPressed: null),
        ),
      );
      await tester.pumpAndSettle();

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('secondary variant renders via InkWell', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Secondary',
            onPressed: () {},
            variant: MpButtonVariant.secondary,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Secondary'), findsOneWidget);
    });

    testWidgets('destructive variant renders ElevatedButton', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Delete',
            onPressed: () {},
            variant: MpButtonVariant.destructive,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Delete'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('text variant renders TextButton', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpButton(
            label: 'Cancel',
            onPressed: () {},
            variant: MpButtonVariant.text,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
