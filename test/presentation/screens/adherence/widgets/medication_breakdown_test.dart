import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_pill/presentation/screens/adherence/widgets/medication_breakdown.dart';

import '../../../../helpers/widget_test_helpers.dart';

void main() {
  group('MedicationBreakdown', () {
    testWidgets('shows "By Medication" section title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(medications: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('By Medication'), findsOneWidget);
    });

    testWidgets('shows noMedicationData message when list is empty', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(medications: []),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No medication data available'), findsOneWidget);
    });

    testWidgets('shows medication name for a single entry', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 85.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
    });

    testWidgets('shows percentage text for a medication with data', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 85.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('85%'), findsOneWidget);
    });

    testWidgets('shows "No Data" when percentage is null', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Metformin', percentage: null),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('shows multiple medication rows', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 90.0),
              (id: 'med-2', name: 'Metformin', percentage: 70.0),
              (id: 'med-3', name: 'Lisinopril', percentage: 50.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Metformin'), findsOneWidget);
      expect(find.text('Lisinopril'), findsOneWidget);
    });

    testWidgets('shows correct percentage values for multiple medications', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 90.0),
              (id: 'med-2', name: 'Metformin', percentage: 65.0),
              (id: 'med-3', name: 'Lisinopril', percentage: 40.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('90%'), findsOneWidget);
      expect(find.text('65%'), findsOneWidget);
      expect(find.text('40%'), findsOneWidget);
    });

    testWidgets('renders medication icon for each row', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 80.0),
              (id: 'med-2', name: 'Metformin', percentage: 60.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.medication), findsNWidgets(2));
    });

    testWidgets('rounds percentage to nearest integer', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 84.6),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 84.6 rounds to 85
      expect(find.text('85%'), findsOneWidget);
    });

    testWidgets('does not show noMedicationData when medications provided', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 80.0),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No medication data available'), findsNothing);
    });

    testWidgets('mixed null and non-null percentages render correctly', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationBreakdown(
            medications: [
              (id: 'med-1', name: 'Aspirin', percentage: 75.0),
              (id: 'med-2', name: 'Metformin', percentage: null),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('75%'), findsOneWidget);
      expect(find.text('No Data'), findsOneWidget);
    });
  });
}
