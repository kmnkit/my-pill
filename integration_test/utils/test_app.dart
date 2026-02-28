/// Test app wrapper with provider overrides for E2E testing
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/app.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/models/reminder.dart';
import 'package:kusuridoki/data/models/adherence_record.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/models/caregiver_link.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/presentation/router/app_router_provider.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_alerts_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_dashboard_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_notifications_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_settings_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/family_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/invite_handler_screen.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_bottom_nav_bar.dart';

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
      // CRITICAL: userProfile must be null for new users
      // If a profile exists, the settings provider auto-migrates it to onboardingComplete: true
      userProfile: null,
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

/// Build a test app for caregiver E2E tests that bypasses router auth checks.
///
/// The production [appRouterProvider] router uses [FirebaseAuth.instance.currentUser]
/// directly in its redirect logic, which cannot be overridden in tests.
/// This helper creates an isolated test router for the caregiver shell.
///
/// [initialRoute]: Starting route (default: '/caregiver/patients')
/// [mockCfService]: Optional [MockCloudFunctionsService] for invite/revoke flows
/// [mockFsService]: Optional [MockFirestoreService] for patient monitoring data
/// [patientsOverride]: If provided, overrides [caregiverPatientsProvider] with
///   this list — used for "dashboard with patients" tests. If null, the provider
///   returns an empty stream (auth is null → no user).
Widget buildCaregiverTestApp(
  TestAppConfig config, {
  String initialRoute = '/caregiver/patients',
  MockCloudFunctionsService? mockCfService,
  MockFirestoreService? mockFsService,
  List<({String patientId, String patientName, DateTime? linkedAt})>?
      patientsOverride,
}) {
  final storageService = MockStorageService(
    medications: config.medications,
    schedules: config.schedules,
    reminders: config.reminders,
    adherenceRecords: config.adherenceRecords,
    caregiverLinks: config.caregiverLinks,
    userProfile: config.userProfile,
  );

  final authService = MockAuthService();
  final cfService = mockCfService ?? MockCloudFunctionsService();
  final fsService = mockFsService ?? MockFirestoreService();

  final overrides = [
    storageServiceProvider.overrideWithValue(storageService),
    authServiceProvider.overrideWithValue(authService),
    cloudFunctionsServiceProvider.overrideWithValue(cfService),
    firestoreServiceProvider.overrideWithValue(fsService),
    // Override router to bypass FirebaseAuth.instance.currentUser redirect
    appRouterProvider.overrideWith(
      (_) => _buildCaregiverTestRouter(initialRoute),
    ),
    if (patientsOverride != null)
      caregiverPatientsProvider.overrideWith(
        (_) => Stream.value(patientsOverride),
      ),
  ];

  return ProviderScope(
    overrides: overrides,
    child: const MyPillApp(),
  );
}

/// Build an isolated [GoRouter] for caregiver E2E tests.
///
/// Starts at [initialRoute] with no auth redirect. Covers all caregiver
/// shell tabs plus standalone routes used in family screen and invite tests.
GoRouter _buildCaregiverTestRouter(String initialRoute) {
  return GoRouter(
    initialLocation: initialRoute,
    redirect: (_, _) => null,
    routes: [
      // Caregiver shell (4 tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _TestCaregiverShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/caregiver/patients',
                builder: (_, _) => const CaregiverDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/caregiver/notifications',
                builder: (_, _) => const CaregiverNotificationsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/caregiver/alerts',
                builder: (_, _) => const CaregiverAlertsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/caregiver/settings',
                builder: (_, _) => const CaregiverSettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Standalone route: patient-side family screen
      GoRoute(
        path: '/settings/family',
        builder: (_, _) => const FamilyScreen(),
      ),
      // Standalone route: invite handler
      GoRoute(
        path: '/invite/:code',
        builder: (context, state) => InviteHandlerScreen(
          inviteCode: state.pathParameters['code'] ?? '',
        ),
      ),
      // Destination for "switch to patient view" navigation
      GoRoute(
        path: '/home',
        builder: (_, _) => const Scaffold(body: SizedBox()),
      ),
    ],
  );
}

/// Minimal caregiver shell scaffold with bottom navigation for testing.
class _TestCaregiverShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _TestCaregiverShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: navigationShell,
      bottomNavigationBar: MpBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        mode: MpNavMode.caregiver,
      ),
    );
  }
}
