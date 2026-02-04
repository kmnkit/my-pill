/// Test app wrapper with provider overrides for E2E testing
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/app.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/models/reminder.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/models/caregiver_link.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/providers/auth_provider.dart';

import 'mock_services.dart';
import 'test_data.dart';

/// Configuration for test app state
class TestAppConfig {
  /// Whether onboarding is complete
  final bool onboardingComplete;

  /// User role ('patient' or 'caregiver')
  final String userRole;

  /// User profile for the test
  final UserProfile? userProfile;

  /// Initial medications to populate
  final List<Medication> medications;

  /// Initial schedules to populate
  final List<Schedule> schedules;

  /// Initial reminders to populate
  final List<Reminder> reminders;

  /// Initial adherence records to populate
  final List<AdherenceRecord> adherenceRecords;

  /// Initial caregiver links to populate
  final List<CaregiverLink> caregiverLinks;

  /// Whether the user should be authenticated
  final bool isAuthenticated;

  /// Whether the user has premium subscription
  final bool isPremium;

  /// Whether notification permissions are granted
  final bool notificationsEnabled;

  const TestAppConfig({
    this.onboardingComplete = false,
    this.userRole = 'patient',
    this.userProfile,
    this.medications = const [],
    this.schedules = const [],
    this.reminders = const [],
    this.adherenceRecords = const [],
    this.caregiverLinks = const [],
    this.isAuthenticated = false,
    this.isPremium = false,
    this.notificationsEnabled = true,
  });

  /// Create config for a new user (onboarding not complete)
  factory TestAppConfig.newUser() {
    return TestAppConfig(
      onboardingComplete: false,
      userProfile: TestData.newUserProfile,
    );
  }

  /// Create config for a patient with completed onboarding
  factory TestAppConfig.patient({
    List<Medication>? medications,
    List<Schedule>? schedules,
    List<Reminder>? reminders,
    List<AdherenceRecord>? adherenceRecords,
    bool isPremium = false,
  }) {
    return TestAppConfig(
      onboardingComplete: true,
      userRole: 'patient',
      userProfile: TestData.completedOnboardingPatient,
      medications: medications ?? [],
      schedules: schedules ?? [],
      reminders: reminders ?? [],
      adherenceRecords: adherenceRecords ?? [],
      isAuthenticated: true,
      isPremium: isPremium,
    );
  }

  /// Create config for a caregiver with completed onboarding
  factory TestAppConfig.caregiver({
    List<CaregiverLink>? caregiverLinks,
    bool isPremium = false,
  }) {
    return TestAppConfig(
      onboardingComplete: true,
      userRole: 'caregiver',
      userProfile: TestData.completedOnboardingCaregiver,
      caregiverLinks: caregiverLinks ?? [],
      isAuthenticated: true,
      isPremium: isPremium,
    );
  }

  /// Create config for a patient with sample medication data
  factory TestAppConfig.patientWithMedications() {
    return TestAppConfig.patient(
      medications: TestData.sampleMedications,
      schedules: [
        TestData.dailySchedule,
        TestData.specificDaysSchedule,
        TestData.intervalSchedule,
      ],
      reminders: TestData.todayReminders(),
    );
  }

  /// Create config for adherence testing
  factory TestAppConfig.patientWithAdherence() {
    return TestAppConfig.patient(
      medications: [TestData.sampleMedication],
      schedules: [TestData.dailySchedule],
      adherenceRecords: TestData.weeklyAdherenceRecords(),
    );
  }
}

/// Test app container that holds mock services and provides access for assertions
class TestAppContainer {
  final MockStorageService storageService;
  final MockAuthService authService;
  final MockNotificationService notificationService;
  final MockSubscriptionService subscriptionService;
  final ProviderContainer container;

  TestAppContainer._({
    required this.storageService,
    required this.authService,
    required this.notificationService,
    required this.subscriptionService,
    required this.container,
  });

  /// Create a test app container with the given configuration
  factory TestAppContainer.create(TestAppConfig config) {
    final storageService = MockStorageService(
      medications: config.medications,
      schedules: config.schedules,
      reminders: config.reminders,
      adherenceRecords: config.adherenceRecords,
      caregiverLinks: config.caregiverLinks,
      userProfile: config.userProfile,
    );

    final authService = MockAuthService();
    final notificationService = MockNotificationService();
    final subscriptionService = MockSubscriptionService();

    // Set initial states
    notificationService.setPermissionGranted(config.notificationsEnabled);
    if (config.isPremium) {
      subscriptionService.setPremium(true);
    }

    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        authServiceProvider.overrideWithValue(authService),
      ],
    );

    return TestAppContainer._(
      storageService: storageService,
      authService: authService,
      notificationService: notificationService,
      subscriptionService: subscriptionService,
      container: container,
    );
  }

  /// Dispose resources
  void dispose() {
    authService.dispose();
    subscriptionService.dispose();
    container.dispose();
  }
}

/// Build a test app widget with provider overrides
Widget buildTestApp(TestAppConfig config) {
  final storageService = MockStorageService(
    medications: config.medications,
    schedules: config.schedules,
    reminders: config.reminders,
    adherenceRecords: config.adherenceRecords,
    caregiverLinks: config.caregiverLinks,
    userProfile: config.userProfile,
  );

  final authService = MockAuthService();

  return ProviderScope(
    overrides: [
      storageServiceProvider.overrideWithValue(storageService),
      authServiceProvider.overrideWithValue(authService),
    ],
    child: const MyPillApp(),
  );
}

/// Build a test app with access to the container for assertions
(Widget, TestAppContainer) buildTestAppWithContainer(TestAppConfig config) {
  final container = TestAppContainer.create(config);

  final widget = UncontrolledProviderScope(
    container: container.container,
    child: const MyPillApp(),
  );

  return (widget, container);
}
