import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/weekly_adherence_summary_card.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  group('WeeklyAdherenceSummaryCard', () {
    testWidgets('shows percentage when overallAdherence returns data',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklyAdherenceSummaryCard(),
          overrides: [
            overallAdherenceProvider.overrideWith(
              (ref) => Future.value(0.85),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('85'), findsOneWidget);
      expect(find.byIcon(Icons.bar_chart), findsOneWidget);
    });

    testWidgets('shows card without crash when overallAdherence returns null',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklyAdherenceSummaryCard(),
          overrides: [
            overallAdherenceProvider.overrideWith(
              (ref) => Future.value(null),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(WeeklyAdherenceSummaryCard), findsOneWidget);
    });
  });
}
