import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_bottom_nav_bar.dart';
import 'package:kusuridoki/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:kusuridoki/presentation/screens/onboarding/login_screen.dart';
import 'package:kusuridoki/presentation/screens/home/home_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medications_list_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/add_medication_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/medication_detail_screen.dart';
import 'package:kusuridoki/presentation/screens/schedule/schedule_screen.dart';
import 'package:kusuridoki/presentation/screens/adherence/weekly_summary_screen.dart';
import 'package:kusuridoki/presentation/screens/medications/edit_medication_screen.dart';
import 'package:kusuridoki/presentation/screens/travel/travel_mode_screen.dart';
import 'package:kusuridoki/presentation/screens/settings/settings_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/family_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_dashboard_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_notifications_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_alerts_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/caregiver_settings_screen.dart';
import 'package:kusuridoki/presentation/screens/caregivers/invite_handler_screen.dart';
import 'package:kusuridoki/presentation/screens/premium/premium_upsell_screen.dart';
import 'package:kusuridoki/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

part 'app_router_provider.g.dart';

/// A ChangeNotifier that listens to user settings and auth state changes
class RouterRefreshNotifier extends ChangeNotifier {
  UserProfile? _settings;
  bool _isAuthenticated = false;

  void update(UserProfile? settings) {
    if (_settings?.onboardingComplete != settings?.onboardingComplete ||
        _settings?.userRole != settings?.userRole) {
      _settings = settings;
      notifyListeners();
    }
    _settings = settings;
  }

  void updateAuth(bool isAuthenticated) {
    if (_isAuthenticated != isAuthenticated) {
      _isAuthenticated = isAuthenticated;
      notifyListeners();
    }
  }
}

@riverpod
RouterRefreshNotifier routerRefreshNotifier(Ref ref) {
  final notifier = RouterRefreshNotifier();

  ref.listen(userSettingsProvider, (previous, next) {
    next.whenData((settings) {
      notifier.update(settings);
    });
  });

  ref.listen(authStateProvider, (previous, next) {
    next.whenData((user) {
      notifier.updateAuth(user != null);
    });
  });

  return notifier;
}

@riverpod
Raw<GoRouter> appRouter(Ref ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);

  // Get initial settings synchronously if available
  UserProfile? currentSettings;
  ref.listen(userSettingsProvider, (previous, next) {
    next.whenData((settings) {
      currentSettings = settings;
    });
  }, fireImmediately: true);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refreshNotifier,
    onException: (_, state, router) {
      // Handle unknown routes gracefully:
      // - Firebase Auth OAuth callback URLs (Google/Apple sign-in redirects)
      // - Root path "/" which has no defined route
      // - Any other unexpected deep links
      // The redirect logic will then handle auth state appropriately.
      router.go('/home');
    },
    redirect: (context, state) {
      final isSplashRoute = state.matchedLocation == '/splash';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      final isLoginRoute = state.matchedLocation == '/login';
      final isInviteRoute = state.matchedLocation.startsWith('/invite/');

      // Allow splash to pass through
      if (isSplashRoute) return null;

      // Invite deep links require authentication
      if (isInviteRoute) {
        final isAuthenticated = FirebaseAuth.instance.currentUser != null;
        if (!isAuthenticated) {
          // Preserve invite code in query param for post-auth handling
          final invitePath = state.matchedLocation;
          return '/login?redirect=$invitePath';
        }
        return null;
      }

      final isAuthenticated = FirebaseAuth.instance.currentUser != null;

      // If we don't have settings yet, allow onboarding/login
      if (currentSettings == null) {
        if (isOnboardingRoute || isLoginRoute) return null;
        return '/onboarding';
      }

      final onboardingComplete = currentSettings!.onboardingComplete;
      final userRole = currentSettings!.userRole;

      // Not completed onboarding -> redirect to onboarding
      if (!onboardingComplete && !isOnboardingRoute) {
        return '/onboarding';
      }

      // Completed onboarding but on onboarding screen -> go to login
      if (onboardingComplete && isOnboardingRoute) {
        return '/login';
      }

      // Not authenticated -> redirect to login (check BEFORE home redirect)
      if (!isAuthenticated && !isLoginRoute && onboardingComplete) {
        return '/login';
      }

      // Authenticated but on login screen -> redirect to appropriate home
      if (isAuthenticated && isLoginRoute) {
        return userRole == 'caregiver' ? '/caregiver/patients' : '/home';
      }

      return null;
    },
    routes: [
      // Standalone route: Splash
      GoRoute(
        path: '/splash',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),

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

      // Standalone route: Premium Upsell
      GoRoute(
        path: '/premium',
        name: RouteNames.premium,
        builder: (context, state) => const PremiumUpsellScreen(),
      ),

      // Standalone medication sub-routes (no bottom nav)
      GoRoute(
        path: '/medications/add',
        name: RouteNames.addMedication,
        builder: (context, state) => const AddMedicationScreen(),
      ),
      GoRoute(
        path: '/medications/:id',
        name: RouteNames.medicationDetail,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MedicationDetailScreen(medicationId: id);
        },
      ),
      GoRoute(
        path: '/medications/:id/edit',
        name: RouteNames.editMedication,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return EditMedicationScreen(medicationId: id);
        },
      ),
      GoRoute(
        path: '/medications/:id/schedule',
        name: RouteNames.setSchedule,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ScheduleScreen(medicationId: id);
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

          // Tab 2: Medications (list only, sub-routes are standalone)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/medications',
                name: RouteNames.medications,
                builder: (context, state) => const MedicationsListScreen(),
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
                builder: (context, state) =>
                    const CaregiverNotificationsScreen(),
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
}

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
      extendBody: true,
      backgroundColor: Colors.transparent,
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
      extendBody: true,
      backgroundColor: Colors.transparent,
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
