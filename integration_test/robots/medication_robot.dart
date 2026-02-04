/// Robot/Page Object for medication management interactions
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Robot pattern class for interacting with medication screens
class MedicationRobot {
  final WidgetTester tester;

  MedicationRobot(this.tester);

  // ===== FINDERS =====

  // Medications list screen
  Finder get medicationsListTitle => find.text('My Medications');
  Finder get addMedicationButton => find.byIcon(Icons.add);
  Finder get searchField => find.byType(TextField);
  Finder get emptyStateText => find.text('No medications added yet');
  Finder get noResultsText => find.text('No medications found');
  Finder get lowStockBadge => find.text('Low');
  Finder get okStockBadge => find.text('OK');

  // Add medication screen
  Finder get addMedicationTitle => find.text('Add Medication');
  Finder get nameField => find.widgetWithText(TextField, 'Medication Name');
  Finder get nameFieldByHint => find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.hintText?.contains('Aspirin') ?? false),
      );
  Finder get dosageField => find.widgetWithText(TextField, 'Dosage');
  Finder get saveMedicationButton => find.text('Save Medication');
  Finder get criticalSwitch => find.byType(SwitchListTile);

  // Medication detail screen
  Finder get editButton => find.byIcon(Icons.edit);
  Finder get deleteButton => find.byIcon(Icons.delete);
  Finder get confirmDeleteButton => find.text('Delete');
  Finder get cancelButton => find.text('Cancel');

  // Navigation
  Finder get backButton => find.byIcon(Icons.arrow_back);

  /// Find a medication card by name
  Finder medicationCard(String name) => find.text(name);

  /// Find dosage text
  Finder dosageText(String dosage) => find.textContaining(dosage);

  // ===== ASSERTIONS =====

  /// Verify we're on the medications list screen
  Future<void> verifyOnMedicationsList() async {
    await tester.pumpAndSettle();
    expect(medicationsListTitle, findsOneWidget);
  }

  /// Verify we're on the add medication screen
  Future<void> verifyOnAddMedication() async {
    await tester.pumpAndSettle();
    expect(addMedicationTitle, findsOneWidget);
    expect(saveMedicationButton, findsOneWidget);
  }

  /// Verify empty state is shown
  Future<void> verifyEmptyState() async {
    await tester.pumpAndSettle();
    expect(emptyStateText, findsOneWidget);
  }

  /// Verify a medication exists in the list
  Future<void> verifyMedicationInList(String name) async {
    await tester.pumpAndSettle();
    expect(medicationCard(name), findsOneWidget);
  }

  /// Verify a medication does not exist in the list
  Future<void> verifyMedicationNotInList(String name) async {
    await tester.pumpAndSettle();
    expect(medicationCard(name), findsNothing);
  }

  /// Verify low stock indicator is shown for a medication
  Future<void> verifyLowStockIndicator() async {
    await tester.pumpAndSettle();
    expect(lowStockBadge, findsWidgets);
  }

  /// Verify no results found message
  Future<void> verifyNoSearchResults() async {
    await tester.pumpAndSettle();
    expect(noResultsText, findsOneWidget);
  }

  // ===== ACTIONS =====

  /// Navigate to add medication screen
  Future<void> tapAddMedication() async {
    await tester.tap(addMedicationButton);
    await tester.pumpAndSettle();
  }

  /// Enter medication name
  Future<void> enterMedicationName(String name) async {
    // Find the first TextField which is the name field
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.first, name);
    await tester.pumpAndSettle();
  }

  /// Enter dosage value
  Future<void> enterDosage(String dosage) async {
    // Find the second TextField which is the dosage field
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(1), dosage);
    await tester.pumpAndSettle();
  }

  /// Select dosage unit from dropdown
  Future<void> selectDosageUnit(String unit) async {
    await tester.tap(find.byType(DropdownButtonFormField<dynamic>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(unit).last);
    await tester.pumpAndSettle();
  }

  /// Toggle critical medication switch
  Future<void> toggleCritical() async {
    await tester.tap(criticalSwitch);
    await tester.pumpAndSettle();
  }

  /// Save the medication
  Future<void> tapSaveMedication() async {
    await tester.tap(saveMedicationButton);
    await tester.pumpAndSettle();
  }

  /// Search for a medication
  Future<void> searchMedication(String query) async {
    await tester.enterText(searchField, query);
    await tester.pumpAndSettle();
  }

  /// Clear search
  Future<void> clearSearch() async {
    await tester.enterText(searchField, '');
    await tester.pumpAndSettle();
  }

  /// Tap on a medication to view details
  Future<void> tapMedication(String name) async {
    await tester.tap(medicationCard(name));
    await tester.pumpAndSettle();
  }

  /// Tap edit button
  Future<void> tapEdit() async {
    await tester.tap(editButton);
    await tester.pumpAndSettle();
  }

  /// Tap delete button
  Future<void> tapDelete() async {
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
  }

  /// Confirm deletion in dialog
  Future<void> confirmDelete() async {
    await tester.tap(confirmDeleteButton);
    await tester.pumpAndSettle();
  }

  /// Cancel deletion in dialog
  Future<void> cancelDelete() async {
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  }

  /// Go back
  Future<void> tapBack() async {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
  }

  /// Scroll to find a widget
  Future<void> scrollToWidget(Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
  }

  // ===== FLOWS =====

  /// Add a new medication with basic info
  Future<void> addMedication({
    required String name,
    required String dosage,
    String? unit,
    bool isCritical = false,
  }) async {
    await tapAddMedication();
    await verifyOnAddMedication();

    await enterMedicationName(name);
    await enterDosage(dosage);

    if (unit != null) {
      await selectDosageUnit(unit);
    }

    if (isCritical) {
      await scrollToWidget(criticalSwitch);
      await toggleCritical();
    }

    await scrollToWidget(saveMedicationButton);
    await tapSaveMedication();

    // Should navigate back to list
    await verifyOnMedicationsList();
  }

  /// Delete a medication
  Future<void> deleteMedication(String name) async {
    await tapMedication(name);
    await tapDelete();
    await confirmDelete();
    await verifyOnMedicationsList();
    await verifyMedicationNotInList(name);
  }

  /// Search and verify results
  Future<void> searchAndVerify(String query, {bool expectResults = true}) async {
    await searchMedication(query);

    if (expectResults) {
      expect(noResultsText, findsNothing);
    } else {
      await verifyNoSearchResults();
    }
  }
}
