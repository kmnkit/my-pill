import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_card.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpCard', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpCard(
            useGlass: false,
            child: Text('Card content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Card content'), findsOneWidget);
    });

    testWidgets('onTap fires when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpCard(
            useGlass: false,
            onTap: () => tapped = true,
            child: const Text('Tap me'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('renders without onTap (non-interactive)', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpCard(
            useGlass: false,
            child: Text('Static card'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Static card'), findsOneWidget);
      // No GestureDetector when onTap is null
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('accepts custom padding', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpCard(
            useGlass: false,
            padding: EdgeInsets.all(8),
            child: Text('Padded'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('renders correctly with glass disabled', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpCard(
            useGlass: false,
            child: Icon(Icons.star),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
