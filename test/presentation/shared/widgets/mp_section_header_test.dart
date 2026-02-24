import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpSectionHeader', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpSectionHeader(title: 'My Medications'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Medications'), findsOneWidget);
    });

    testWidgets('does not render action button when actionLabel not provided',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpSectionHeader(title: 'Section'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('renders action button when actionLabel provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          MpSectionHeader(
            title: 'Section',
            actionLabel: 'See all',
            onAction: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('See all'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('onAction fires when action button tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createTestableWidget(
          MpSectionHeader(
            title: 'Section',
            actionLabel: 'See all',
            onAction: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('See all'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
