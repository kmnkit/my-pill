import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('KdSectionHeader', () {
    testWidgets('renders title text', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(const KdSectionHeader(title: 'My Medications')),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Medications'), findsOneWidget);
    });

    testWidgets('does not render action button when actionLabel not provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(const KdSectionHeader(title: 'Section')),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsNothing);
    });

    testWidgets('renders action button when actionLabel provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          KdSectionHeader(
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
          KdSectionHeader(
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
