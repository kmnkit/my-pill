import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpEmptyState', () {
    testWidgets('renders icon and title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpEmptyState(
            icon: Icons.inbox,
            title: 'Nothing here',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.inbox), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('renders optional description when provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpEmptyState(
            icon: Icons.inbox,
            title: 'No items',
            description: 'Add something to get started',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add something to get started'), findsOneWidget);
    });

    testWidgets('description is absent when not provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpEmptyState(
            icon: Icons.inbox,
            title: 'Empty',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Only the title text should be visible
      expect(find.text('Empty'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets('renders action button when actionLabel and onAction provided',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpEmptyState(
            icon: Icons.add,
            title: 'Empty',
            actionLabel: 'Add item',
            onAction: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add item'), findsOneWidget);
      await tester.tap(find.text('Add item'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('action button absent when actionLabel not provided',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpEmptyState(
            icon: Icons.inbox,
            title: 'Empty',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ElevatedButton), findsNothing);
    });
  });
}
