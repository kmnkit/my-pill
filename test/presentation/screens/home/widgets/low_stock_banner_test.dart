import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/low_stock_banner.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_alert_banner.dart';

import '../../../../helpers/widget_test_helpers.dart';

class _ErrorMedicationList extends MedicationList {
  @override
  Future<List<Medication>> build() async => throw Exception('load error');
}

class FakeMedicationList extends MedicationList {
  final List<Medication> _meds;
  FakeMedicationList(this._meds);

  @override
  Future<List<Medication>> build() async => _meds;
}

Medication _makeMedication({
  String id = 'med-1',
  String name = 'Aspirin',
  int inventoryRemaining = 30,
  int inventoryTotal = 30,
  int lowStockThreshold = 5,
}) {
  return Medication(
    id: id,
    name: name,
    dosage: 100,
    dosageUnit: DosageUnit.mg,
    shape: PillShape.round,
    color: PillColor.white,
    inventoryTotal: inventoryTotal,
    inventoryRemaining: inventoryRemaining,
    lowStockThreshold: lowStockThreshold,
    createdAt: DateTime(2024, 1, 1),
  );
}

void main() {
  group('LowStockBanner', () {
    testWidgets('hidden when no medications', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList([])),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsNothing);
    });

    testWidgets('hidden when all medications have sufficient stock', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          inventoryRemaining: 20,
          lowStockThreshold: 5,
        ),
        _makeMedication(
          id: 'med-2',
          name: 'Vitamin C',
          inventoryRemaining: 15,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsNothing);
    });

    testWidgets('shows banner when a medication is at low stock threshold', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          name: 'Aspirin',
          inventoryRemaining: 5,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsOneWidget);
    });

    testWidgets('shows banner when a medication is below low stock threshold', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          name: 'Metformin',
          inventoryRemaining: 2,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsOneWidget);
      expect(find.textContaining('Metformin'), findsOneWidget);
    });

    testWidgets('shows banner with medication name and remaining count', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          name: 'Lisinopril',
          inventoryRemaining: 3,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Lisinopril'), findsOneWidget);
      expect(find.textContaining('3'), findsOneWidget);
    });

    testWidgets('shows first low stock medication when multiple exist', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          name: 'FirstLowStock',
          inventoryRemaining: 2,
          lowStockThreshold: 5,
        ),
        _makeMedication(
          id: 'med-2',
          name: 'SecondLowStock',
          inventoryRemaining: 1,
          lowStockThreshold: 5,
        ),
        _makeMedication(
          id: 'med-3',
          name: 'Normal',
          inventoryRemaining: 20,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Only one banner shown (for the first low stock medication)
      expect(find.byType(KdAlertBanner), findsOneWidget);
      expect(find.textContaining('FirstLowStock'), findsOneWidget);
    });

    testWidgets('hidden when provider is in error state', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => _ErrorMedicationList()),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsNothing);
    });

    testWidgets('hidden when medication has stock just above threshold', (
      tester,
    ) async {
      final meds = [
        _makeMedication(
          id: 'med-1',
          name: 'Aspirin',
          inventoryRemaining: 6,
          lowStockThreshold: 5,
        ),
      ];

      await tester.pumpWidget(
        createTestableWidget(
          const LowStockBanner(),
          overrides: [
            medicationListProvider.overrideWith(() => FakeMedicationList(meds)),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KdAlertBanner), findsNothing);
    });
  });
}
