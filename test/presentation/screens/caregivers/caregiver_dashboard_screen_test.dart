import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_dashboard_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

void main() {
  group('CaregiverDashboardScreen', () {
    testWidgets('shows IconButton when canAdd is true (empty patient list)',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const CaregiverDashboardScreen(),
          overrides: [
            caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
            canAddPatientProvider.overrideWith((ref) => Future.value(true)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_add), findsOneWidget);
    });

    testWidgets('hides IconButton when canAdd is false (free tier limit)',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const CaregiverDashboardScreen(),
          overrides: [
            caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
            canAddPatientProvider.overrideWith((ref) => Future.value(false)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_add), findsNothing);
    });

    testWidgets('shows connect guide when no patients linked', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const CaregiverDashboardScreen(),
          overrides: [
            caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
            canAddPatientProvider.overrideWith((ref) => Future.value(true)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.people_outline), findsOneWidget);
      expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
      expect(find.text('How to connect'), findsOneWidget);
    });

    testWidgets('shows share guide button in connect guide', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const CaregiverDashboardScreen(),
          overrides: [
            caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
            canAddPatientProvider.overrideWith((ref) => Future.value(true)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.share), findsOneWidget);
    });

    testWidgets('does not show FAB (removed in favour of header IconButton)',
        (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const CaregiverDashboardScreen(),
          overrides: [
            caregiverPatientsProvider.overrideWith((ref) => Stream.value([])),
            canAddPatientProvider.overrideWith((ref) => Future.value(true)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsNothing);
    });
  });
}
