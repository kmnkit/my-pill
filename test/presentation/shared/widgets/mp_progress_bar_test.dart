import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/presentation/shared/widgets/mp_progress_bar.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('MpProgressBar', () {
    testWidgets('renders LinearProgressIndicator', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpProgressBar(current: 3, total: 10),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });

    testWidgets('renders current/total label by default', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpProgressBar(current: 3, total: 10),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 / 10'), findsOneWidget);
    });

    testWidgets('label hidden when showLabel is false', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpProgressBar(current: 3, total: 10, showLabel: false),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('3 / 10'), findsNothing);
    });

    testWidgets('semantic label includes current, total and percent', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpProgressBar(current: 5, total: 10),
        ),
      );
      await tester.pumpAndSettle();

      // The Semantics widget wraps with a value of '50%'
      final semantics = tester.getSemantics(find.byType(MpProgressBar));
      expect(semantics.value, '50%');
    });

    testWidgets('handles zero total gracefully', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MpProgressBar(current: 0, total: 0),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MpProgressBar), findsOneWidget);
    });

    testWidgets('renders in Japanese locale without error', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const MpProgressBar(current: 2, total: 5),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LinearProgressIndicator), findsOneWidget);
    });
  });
}
