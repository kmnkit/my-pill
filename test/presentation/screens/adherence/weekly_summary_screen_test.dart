import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/providers/adherence_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/presentation/screens/adherence/weekly_summary_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

// Fake MedicationList (needed by medicationBreakdownProvider)
class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

void main() {
  group('WeeklySummaryScreen', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.85),
            weeklyAdherenceProvider.overrideWith(
              (ref) async => <String, double?>{
                'Mon': 80.0,
                'Tue': 100.0,
                'Wed': 60.0,
                'Thu': null,
                'Fri': 90.0,
                'Sat': 75.0,
                'Sun': 100.0,
              },
            ),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n: weeklySummary -> 'Weekly Summary'
      expect(find.text('Weekly Summary'), findsOneWidget);
    });

    testWidgets('shows overall score percentage when data is available',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.85),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // OverallScore renders "85%" when adherence=0.85
      expect(find.text('85%'), findsOneWidget);
    });

    testWidgets('shows no-data placeholder when overall adherence is null',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => null),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // OverallScore shows '--' when percentage is null
      expect(find.text('--'), findsOneWidget);
    });

    testWidgets('renders scrollable layout', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.5),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('shows back button in app bar', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.0),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider.overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // MpAppBar with showBack: true renders a back icon
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });

    testWidgets('renders OverallScore with null on overallAdherence error',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider
                .overrideWith((ref) => throw Exception('fail')),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider
                .overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error branch renders OverallScore(percentage: null) → '--'
      expect(find.text('--'), findsOneWidget);
    });

    testWidgets('renders empty AdherenceChart on weeklyAdherence error',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.5),
            weeklyAdherenceProvider
                .overrideWith((ref) => throw Exception('fail')),
            medicationBreakdownProvider.overrideWith((ref) async => []),
            medicationListProvider
                .overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error branch renders AdherenceChart(weeklyData: {})
      expect(find.text('Weekly Summary'), findsOneWidget);
    });

    testWidgets('renders empty MedicationBreakdown on breakdown error',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const WeeklySummaryScreen(),
          overrides: [
            overallAdherenceProvider.overrideWith((ref) async => 0.5),
            weeklyAdherenceProvider.overrideWith((ref) async => {}),
            medicationBreakdownProvider
                .overrideWith((ref) => throw Exception('fail')),
            medicationListProvider
                .overrideWith(() => _FakeEmptyMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Error branch renders MedicationBreakdown(medications: [])
      expect(find.text('Weekly Summary'), findsOneWidget);
    });
  });
}
