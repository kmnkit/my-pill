import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/presentation/screens/medications/medications_list_screen.dart';

import '../../../helpers/widget_test_helpers.dart';

// Fake AsyncNotifier returning an empty list
class _FakeEmptyMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [];
}

// Fake AsyncNotifier returning one medication
class _FakePopulatedMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [
    Medication(
      id: 'med1',
      name: 'Aspirin',
      dosage: 100,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.round,
      color: PillColor.white,
      inventoryTotal: 30,
      inventoryRemaining: 20,
      lowStockThreshold: 5,
      createdAt: DateTime(2024),
    ),
    Medication(
      id: 'med2',
      name: 'Vitamin C',
      dosage: 500,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.capsule,
      color: PillColor.orange,
      inventoryTotal: 60,
      inventoryRemaining: 3,
      lowStockThreshold: 5,
      createdAt: DateTime(2024),
    ),
  ];
}

// Fake AsyncNotifier returning error
class _FakeErrorMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async =>
      throw Exception('Storage unavailable');
}

void main() {
  group('MedicationsListScreen', () {
    testWidgets('renders app bar title', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n key: myMedications -> "My Medications"
      expect(find.text('My Medications'), findsOneWidget);
    });

    testWidgets('shows empty state when medication list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.medication), findsOneWidget);
    });

    testWidgets('shows medication names when list has items', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Vitamin C'), findsOneWidget);
    });

    testWidgets('shows low stock badge when inventory is below threshold', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Vitamin C has inventoryRemaining=3, lowStockThreshold=5 → low stock
      expect(find.text('Low Stock'), findsOneWidget);
    });

    testWidgets('shows error state when provider throws', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeErrorMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n key: errorLoadingMedications
      expect(find.text('Error loading medications'), findsOneWidget);
    });

    testWidgets('renders search field', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('filters medications by search query', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Both medications visible before search
      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Vitamin C'), findsOneWidget);

      // Enter search query matching only one medication
      await tester.enterText(find.byType(TextField), 'Aspirin');
      await tester.pumpAndSettle();

      // 'Aspirin' appears in both TextField and list item
      expect(find.text('Aspirin'), findsAtLeastNWidgets(1));
      expect(find.text('Vitamin C'), findsNothing);
    });

    testWidgets('search is case-insensitive', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'aspirin');
      await tester.pump();

      expect(find.text('Aspirin'), findsOneWidget);
      expect(find.text('Vitamin C'), findsNothing);
    });

    testWidgets(
      'shows no medications found empty state when search yields no results',
      (tester) async {
        await tester.pumpWidget(
          createTestableWidget(
            const MedicationsListScreen(),
            overrides: [
              medicationListProvider.overrideWith(
                () => _FakePopulatedMedicationList(),
              ),
            ],
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'XYZ_NONEXISTENT');
        await tester.pump();

        // l10n key: noMedicationsFound -> "No medications found"
        expect(find.text('No medications found'), findsOneWidget);
      },
    );

    testWidgets('shows retry button in error state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeErrorMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // l10n key: retry -> "Retry"
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows loading indicator while data is loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeSlowMedicationList(),
            ),
          ],
        ),
      );
      // Only pump once — do not settle — so loading state is visible
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows OK badge when stock is above threshold', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakePopulatedMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Aspirin has inventoryRemaining=20, lowStockThreshold=5 → OK
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('medication name truncates with ellipsis for long names', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeLongNameMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Widget renders without overflow — just ensure it renders
      expect(find.byType(MedicationsListScreen), findsOneWidget);
      // The Text widget for the name should be present with ellipsis overflow
      final textWidgets = tester.widgetList<Text>(find.byType(Text)).toList();
      final nameText = textWidgets.firstWhere(
        (t) => t.data != null && t.data!.contains('Acetylsalicylic'),
        orElse: () => throw TestFailure('Long medication name text not found'),
      );
      expect(nameText.overflow, TextOverflow.ellipsis);
    });

    testWidgets('tapping retry button in error state does not crash', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeErrorMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // After retry, still shows error (fake always throws)
      expect(find.text('Error loading medications'), findsOneWidget);
    });

    testWidgets('shows add icon button in app bar', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const MedicationsListScreen(),
          overrides: [
            medicationListProvider.overrideWith(
              () => _FakeEmptyMedicationList(),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}

// Fake AsyncNotifier that stays loading (never completes)
class _FakeSlowMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() {
    // Use a Completer that never completes to avoid pending timer issues
    return Completer<List<Medication>>().future;
  }
}

// Fake AsyncNotifier with a medication that has a very long name
class _FakeLongNameMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => [
    Medication(
      id: 'med-long',
      name:
          'Acetylsalicylic Acid Extra Strength Formula 500mg Extended Release',
      dosage: 500,
      dosageUnit: DosageUnit.mg,
      shape: PillShape.round,
      color: PillColor.white,
      inventoryTotal: 30,
      inventoryRemaining: 20,
      lowStockThreshold: 5,
      createdAt: DateTime(2024),
    ),
  ];
}
