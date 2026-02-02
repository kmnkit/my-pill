import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/presentation/router/route_names.dart';
import 'package:my_pill/presentation/shared/widgets/mp_bottom_nav_bar.dart';
import 'package:my_pill/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:my_pill/presentation/screens/onboarding/login_screen.dart';
import 'package:my_pill/presentation/screens/home/home_screen.dart';
import 'package:my_pill/presentation/screens/medications/medications_list_screen.dart';
import 'package:my_pill/presentation/screens/medications/add_medication_screen.dart';
import 'package:my_pill/presentation/screens/medications/medication_detail_screen.dart';
import 'package:my_pill/presentation/screens/schedule/schedule_screen.dart';
import 'package:my_pill/presentation/screens/adherence/weekly_summary_screen.dart';
import 'package:my_pill/presentation/screens/medications/edit_medication_screen.dart';
import 'package:my_pill/presentation/screens/travel/travel_mode_screen.dart';
import 'package:my_pill/presentation/screens/settings/settings_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/family_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/caregiver_dashboard_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/caregiver_notifications_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/caregiver_alerts_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/caregiver_settings_screen.dart';
import 'package:my_pill/presentation/screens/caregivers/invite_handler_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    // Standalone route: Onboarding
    GoRoute(
      path: '/onboarding',
      name: RouteNames.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Standalone route: Login
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),

    // Standalone route: Deep link invite handler
    GoRoute(
      path: '/invite/:code',
      name: RouteNames.invite,
      builder: (context, state) {
        final code = state.pathParameters['code'] ?? '';
        return InviteHandlerScreen(inviteCode: code);
      },
    ),

    // Patient ShellRoute (default navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _PatientShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Weekly Adherence
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/adherence',
              name: RouteNames.weeklyAdherence,
              builder: (context, state) => const WeeklySummaryScreen(),
            ),
          ],
        ),

        // Tab 2: Medications (with sub-routes)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/medications',
              name: RouteNames.medications,
              builder: (context, state) => const MedicationsListScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: RouteNames.addMedication,
                  builder: (context, state) => const AddMedicationScreen(),
                ),
                GoRoute(
                  path: ':id',
                  name: RouteNames.medicationDetail,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return MedicationDetailScreen(medicationId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: RouteNames.editMedication,
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return EditMedicationScreen(medicationId: id);
                      },
                    ),
                    GoRoute(
                      path: 'schedule',
                      name: RouteNames.setSchedule,
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return ScheduleScreen(medicationId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Tab 3: Settings (with sub-routes)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: RouteNames.settings,
              builder: (context, state) => const SettingsScreen(),
              routes: [
                GoRoute(
                  path: 'travel',
                  name: RouteNames.travelMode,
                  builder: (context, state) => const TravelModeScreen(),
                ),
                GoRoute(
                  path: 'family',
                  name: RouteNames.familyCaregivers,
                  builder: (context, state) => const FamilyScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Caregiver ShellRoute (alternate navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _CaregiverShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Caregiver Dashboard (Patients)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/caregiver/patients',
              name: RouteNames.caregiverDashboard,
              builder: (context, state) => const CaregiverDashboardScreen(),
            ),
          ],
        ),

        // Tab 1: Caregiver Notifications
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/caregiver/notifications',
              name: RouteNames.caregiverNotifications,
              builder: (context, state) => const CaregiverNotificationsScreen(),
            ),
          ],
        ),

        // Tab 2: Caregiver Alerts
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/caregiver/alerts',
              name: RouteNames.caregiverAlerts,
              builder: (context, state) => const CaregiverAlertsScreen(),
            ),
          ],
        ),

        // Tab 3: Caregiver Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/caregiver/settings',
              name: RouteNames.caregiverSettings,
              builder: (context, state) => const CaregiverSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// Patient Shell Screen with bottom navigation
class _PatientShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const _PatientShellScreen({required this.navigationShell});

  @override
  State<_PatientShellScreen> createState() => _PatientShellScreenState();
}

class _PatientShellScreenState extends State<_PatientShellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: MpBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        mode: MpNavMode.patient,
      ),
    );
  }
}

// Caregiver Shell Screen with bottom navigation
class _CaregiverShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const _CaregiverShellScreen({required this.navigationShell});

  @override
  State<_CaregiverShellScreen> createState() => _CaregiverShellScreenState();
}

class _CaregiverShellScreenState extends State<_CaregiverShellScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: MpBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        mode: MpNavMode.caregiver,
      ),
    );
  }
}
