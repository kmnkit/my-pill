/// Main entry point for E2E integration tests
///
/// This file imports and runs all E2E test suites.
///
/// Usage:
/// ```bash
/// # Run all E2E tests
/// flutter test integration_test/
///
/// # Run specific test file
/// flutter test integration_test/flows/onboarding_test.dart
///
/// # Run with verbose output
/// flutter test integration_test/ --reporter expanded
///
/// # Run on specific device
/// flutter test integration_test/ -d <device_id>
/// ```
library;

import 'package:integration_test/integration_test.dart';

// Import all test flows
import 'flows/onboarding_test.dart' as onboarding;
import 'flows/medication_crud_test.dart' as medication_crud;
import 'flows/reminder_actions_test.dart' as reminder_actions;

void main() {
  // Initialize integration test binding
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Run all test suites
  onboarding.main();
  medication_crud.main();
  reminder_actions.main();
}
