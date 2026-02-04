/// E2E tests for medication CRUD operations
library;

import 'package:flutter_test/flutter_test.dart';

import '../utils/test_app.dart';
import '../utils/test_helpers.dart';
import '../robots/medication_robot.dart';
import '../robots/home_robot.dart';

void main() {
  ensureTestInitialized();

  group('Medication CRUD', () {
    testWidgets('Add new medication with all fields', (tester) async {
      // Arrange: Patient with completed onboarding, no medications
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();
      await medRobot.verifyOnMedicationsList();

      // Act: Add a new medication
      await medRobot.addMedication(
        name: 'Test Aspirin',
        dosage: '100',
        unit: 'mg',
        isCritical: false,
      );

      // Assert: Medication should appear in list
      await medRobot.verifyMedicationInList('Test Aspirin');
    });

    testWidgets('View medication in list', (tester) async {
      // Arrange: Patient with existing medications
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();
      await medRobot.verifyOnMedicationsList();

      // Assert: Sample medications should be visible
      await medRobot.verifyMedicationInList('Aspirin');
      await medRobot.verifyMedicationInList('Blood Pressure Med');
      await medRobot.verifyMedicationInList('Vitamin D');
    });

    testWidgets('View medication detail screen', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();
      await medRobot.verifyOnMedicationsList();

      // Act: Tap on a medication
      await medRobot.tapMedication('Aspirin');
      await tester.pumpAndSettle();

      // Assert: Should see medication details
      expect(find.text('Aspirin'), findsWidgets);
      expect(find.textContaining('100'), findsWidgets);
    });

    testWidgets('Search medications by name', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();
      await medRobot.verifyOnMedicationsList();

      // Act: Search for "Aspirin"
      await medRobot.searchMedication('Aspirin');

      // Assert: Only Aspirin should be visible
      await medRobot.verifyMedicationInList('Aspirin');
      // Other medications should be filtered out
      await medRobot.verifyMedicationNotInList('Vitamin D');
    });

    testWidgets('Search with no results', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();

      // Act: Search for non-existent medication
      await medRobot.searchMedication('NonExistentMed');

      // Assert: Should show no results
      await medRobot.verifyNoSearchResults();
    });

    testWidgets('Low stock indicator displays', (tester) async {
      // Arrange: Include a low stock medication
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();
      await medRobot.verifyOnMedicationsList();

      // Assert: Low stock badge should be visible (Vitamin D has 4 remaining, threshold 5)
      await medRobot.verifyLowStockIndicator();
    });

    testWidgets('Empty state when no medications', (tester) async {
      // Arrange: Patient with no medications
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();

      // Assert: Should show empty state
      await medRobot.verifyEmptyState();
    });

    testWidgets('Clear search returns all medications', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patientWithMedications());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();

      // Act: Search then clear
      await medRobot.searchMedication('Aspirin');
      await medRobot.verifyMedicationNotInList('Vitamin D');

      await medRobot.clearSearch();

      // Assert: All medications should be visible again
      await medRobot.verifyMedicationInList('Aspirin');
      await medRobot.verifyMedicationInList('Vitamin D');
    });

    testWidgets('Add medication validation - empty name', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to add medication
      await homeRobot.goToMedications();
      await medRobot.tapAddMedication();
      await medRobot.verifyOnAddMedication();

      // Act: Try to save without entering name
      await medRobot.enterDosage('100');
      await medRobot.scrollToWidget(medRobot.saveMedicationButton);
      await medRobot.tapSaveMedication();

      // Assert: Should show error and stay on screen
      expect(find.textContaining('name'), findsWidgets);
      await medRobot.verifyOnAddMedication();
    });

    testWidgets('Add medication validation - empty dosage', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to add medication
      await homeRobot.goToMedications();
      await medRobot.tapAddMedication();
      await medRobot.verifyOnAddMedication();

      // Act: Try to save without entering dosage
      await medRobot.enterMedicationName('Test Med');
      await medRobot.scrollToWidget(medRobot.saveMedicationButton);
      await medRobot.tapSaveMedication();

      // Assert: Should show error and stay on screen
      expect(find.textContaining('dosage'), findsWidgets);
      await medRobot.verifyOnAddMedication();
    });

    testWidgets('Add critical medication', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to medications
      await homeRobot.goToMedications();

      // Act: Add a critical medication
      await medRobot.addMedication(
        name: 'Critical Med',
        dosage: '50',
        isCritical: true,
      );

      // Assert: Medication should be in list
      await medRobot.verifyMedicationInList('Critical Med');
    });

    testWidgets('Navigate back from add medication screen', (tester) async {
      // Arrange
      final app = buildTestApp(TestAppConfig.patient());
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();

      final homeRobot = HomeRobot(tester);
      final medRobot = MedicationRobot(tester);

      // Navigate to add medication
      await homeRobot.goToMedications();
      await medRobot.tapAddMedication();
      await medRobot.verifyOnAddMedication();

      // Act: Go back
      await medRobot.tapBack();

      // Assert: Should be back on medications list
      await medRobot.verifyOnMedicationsList();
    });
  });
}
