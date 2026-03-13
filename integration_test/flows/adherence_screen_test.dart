/// E2E tests for adherence screen (WeeklySummaryScreen)
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/overall_score.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/adherence_chart.dart';
import 'package:kusuridoki/presentation/screens/adherence/widgets/medication_breakdown.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/home_robot.dart';

void main() {
  ensureTestInitialized();

  group('Adherence Screen', () {
    testWidgets('AD-01: Adherence screen displays weekly summary sections',
        (tester) async {
      // Arrange: Patient with adherence data
      final app = buildTestApp(TestAppConfig.patientWithAdherence());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);

      // Navigate to adherence tab
      await homeRobot.goToAdherence();

      // Assert: All three sections are present
      expect(find.byType(OverallScore), findsOneWidget);
      expect(find.byType(AdherenceChart), findsOneWidget);
      expect(find.byType(MedicationBreakdown), findsOneWidget);
    });

    testWidgets('AD-02: Empty state when no adherence data', (tester) async {
      // Arrange: Patient with no medications, no adherence records
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);

      // Navigate to adherence tab
      await homeRobot.goToAdherence();

      // Assert: OverallScore shows "--" for no data
      expect(find.text('--'), findsOneWidget);

      // Assert: "No Data" appears in score rating and chart legend
      expect(find.text('No Data'), findsWidgets);

      // Assert: MedicationBreakdown shows empty state
      expect(find.text('No medication data available'), findsOneWidget);
    });

    testWidgets('AD-03: Adherence data displays chart and score',
        (tester) async {
      // Arrange: Patient with adherence records
      final app = buildTestApp(TestAppConfig.patientWithAdherence());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);

      // Navigate to adherence tab
      await homeRobot.goToAdherence();

      // Assert: Score percentage is visible
      expect(find.textContaining('%'), findsWidgets);

      // Assert: Chart legend items visible
      expect(find.text('Taken'), findsWidgets);
      expect(find.text('Missed'), findsWidgets);

      // Assert: Section headers visible
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('By Medication'), findsOneWidget);

      // Assert: Medication name visible in breakdown
      expect(find.text('Aspirin'), findsWidgets);
    });

    testWidgets(
      'AD-04: Export report button display',
      (tester) async {
        // TODO(marco 2026-03): implement export report button test
      },
      skip: true, // test body not yet implemented
    );
  });
}
