import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kusuridoki/core/utils/analytics_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/deep_link_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_bottom_nav_bar.dart';
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

/// Pure redirect decision logic — extracted for testability.
///
/// Returns the redirect destination path, or null to allow the current route.
/// All side effects (e.g. consuming invite codes) are performed via the
/// optional [consumePendingInviteCode] callback.
String? computeRedirect({
  required String matchedLocation,
  required bool isAuthenticated,
  required UserProfile? currentSettings,
  required Map<String, String> queryParameters,
  String? Function()? consumePendingInviteCode,
}) {
  final isOnboardingRoute = matchedLocation == '/onboarding';
  final isLoginRoute = matchedLocation == '/login';
  final isInviteRoute = matchedLocation.startsWith('/invite/');

  // Splash always passes through — it handles its own navigation.
  if (matchedLocation == '/splash') return null;

  // Invite deep links require authentication.
  if (isInviteRoute) {
    if (!isAuthenticated) {
      return '/login?redirect=$matchedLocation';
    }
    // Consume any pending code so it doesn't cause a redundant redirect later.
    consumePendingInviteCode?.call();
    return null;
  }

  // Settings not yet loaded — allow onboarding/login through, redirect others.
  if (currentSettings == null) {
    if (isOnboardingRoute || isLoginRoute) return null;
    return '/onboarding';
  }

  final onboardingComplete = currentSettings.onboardingComplete;
  final isCaregiver = currentSettings.isCaregiver;

  // Not completed onboarding → redirect to onboarding.
  if (!onboardingComplete && !isOnboardingRoute) {
    return '/onboarding';
  }

  // Completed onboarding but on onboarding screen → go to login.
  if (onboardingComplete && isOnboardingRoute) {
    return '/login';
  }

  // Not authenticated → redirect to login.
  // This covers all post-sign-out / post-delete scenarios.
  if (!isAuthenticated && !isLoginRoute && onboardingComplete) {
    return '/login';
  }

  // Authenticated but on login screen → redirect to appropriate home.
  if (isAuthenticated && isLoginRoute) {
    // 1. Honor redirect query param (set when deep link arrived pre-auth).
    final redirectPath = queryParameters['redirect'];
    if (redirectPath != null &&
        redirectPath.isNotEmpty &&
        _isAllowedRedirect(redirectPath)) {
      return redirectPath;
    }
    // 2. Consume pending invite code from cold-start deep link.
    final pendingCode = consumePendingInviteCode?.call();
    if (pendingCode != null) {
      return '/invite/$pendingCode';
    }
    return isCaregiver ? '/caregiver/patients' : '/home';
  }

  // Authenticated users already past /login also need pending invite consumed
  // (e.g. cold-start Universal Link while already signed in).
  if (isAuthenticated && onboardingComplete) {
    final pendingCode = consumePendingInviteCode?.call();
    if (pendingCode != null) {
      return '/invite/$pendingCode';
    }
  }

  return null;
}

/// Allowlist of redirect paths to prevent open redirect within the app.
bool _isAllowedRedirect(String path) {
  const allowedPrefixes = ['/home', '/caregiver/', '/invite/', '/settings', '/adherence', '/medications', '/premium'];
  return allowedPrefixes.any((prefix) => path.startsWith(prefix));
}

/// A ChangeNotifier that listens to user settings and auth state changes
class RouterRefreshNotifier extends ChangeNotifier {
  UserProfile? _settings;
  bool _isAuthenticated = false;

  void update(UserProfile? settings) {
    if (_settings?.onboardingComplete != settings?.onboardingComplete ||
        _settings?.isCaregiver != settings?.isCaregiver) {
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

  void trigger() => notifyListeners();
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
      AnalyticsService.setUserId(user?.uid);
    });
  });

  return notifier;
}

/// Notifier that fires when a warm-start invite code arrives via deep link.
@riverpod
RouterRefreshNotifier inviteRefreshNotifier(Ref ref) {
  final notifier = RouterRefreshNotifier();

  ref.listen<AsyncValue<String>>(inviteCodeProvider, (_, next) {
    next.whenData((_) => notifier.trigger());
  });

  return notifier;
}

@riverpod
Raw<GoRouter> appRouter(Ref ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);
  final inviteNotifier = ref.watch(inviteRefreshProvider);

  // Get initial settings synchronously if available
  UserProfile? currentSettings;
  ref.listen(userSettingsProvider, (previous, next) {
    next.whenData((settings) {
      currentSettings = settings;
    });
  }, fireImmediately: true);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: Listenable.merge([refreshNotifier, inviteNotifier]),
    observers: [
      SentryNavigatorObserver(),
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    onException: (_, state, router) {
      // Handle unknown routes gracefully:
      // - Firebase Auth OAuth callback URLs (Google/Apple sign-in redirects)
      // - Root path "/" which has no defined route
      // - Any other unexpected deep links
      // Use addPostFrameCallback to avoid reentrant navigation during route processing.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final destination = FirebaseAuth.instance.currentUser != null ? '/home' : '/login';
        router.go(destination);
      });
    },
    redirect: (context, state) {
      return computeRedirect(
        matchedLocation: state.matchedLocation,
        isAuthenticated: FirebaseAuth.instance.currentUser != null,
        currentSettings: currentSettings,
        queryParameters: state.uri.queryParameters,
        consumePendingInviteCode: () =>
            ref.read(deepLinkServiceProvider).consumePendingInviteCode(),
      );
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
          final extra = state.extra as Map<String, dynamic>?;
          final isInitialSetup = extra?['isInitialSetup'] as bool? ?? false;
          return ScheduleScreen(medicationId: id, isInitialSetup: isInitialSetup);
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
      bottomNavigationBar: KdBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        mode: KdNavMode.patient,
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
      bottomNavigationBar: KdBottomNavBar(
        currentIndex: widget.navigationShell.currentIndex,
        onTap: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        mode: KdNavMode.caregiver,
      ),
    );
  }
}
