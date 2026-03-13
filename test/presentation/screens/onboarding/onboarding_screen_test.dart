// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:kusuridoki/presentation/screens/onboarding/widgets/onboarding_progress_indicator.dart';

import '../../../helpers/widget_test_helpers.dart';
import '../../../mock_firebase.dart';

// ─── Firebase platform stub ───────────────────────────────────────────────────

class _FakeFirebaseAuthPlatform extends FirebaseAuthPlatform
    with MockPlatformInterfaceMixin {
  _FakeFirebaseAuthPlatform() : super();

  @override
  UserPlatform? get currentUser => null;

  @override
  Stream<UserPlatform?> authStateChanges() =>
      Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> idTokenChanges() => Stream<UserPlatform?>.value(null);

  @override
  Stream<UserPlatform?> userChanges() => Stream<UserPlatform?>.value(null);

  @override
  FirebaseAuthPlatform delegateFor({
    required dynamic app,
    dynamic persistence,
  }) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    dynamic currentUser,
    String? languageCode,
  }) => this;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// ─── UserSettings fake ────────────────────────────────────────────────────────

const _testProfile = UserProfile(
  id: 'local',
  name: null,
  language: 'en',
  highContrast: false,
  textSize: 'normal',
  notificationsEnabled: true,
  criticalAlerts: false,
  snoozeDuration: 15,
  travelModeEnabled: false,
  removeAds: false,
  onboardingComplete: false,
);

class _FakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async => _testProfile;

  @override
  Future<void> updateName(String name) async {}

  @override
  Future<void> updateUserRole(String role) async {}

  @override
  Future<void> updateIsCaregiver(bool value) async {}

  @override
  Future<void> updateHomeTimezone(String timezone) async {}

  @override
  Future<void> updateDefaultIppoka(bool value) async {}

  @override
  Future<void> completeOnboarding() async {}

  @override
  Future<void> updateLanguage(String language) async {}

  @override
  Future<void> updateNotificationsEnabled(bool enabled) async {}
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

List<dynamic> _overrides() {
  return [userSettingsProvider.overrideWith(() => _FakeUserSettings())];
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  setUp(() {
    tz.initializeTimeZones();
    setupFirebaseAuthMocks();
    FirebaseAuthPlatform.instance = _FakeFirebaseAuthPlatform();
  });

  group('OnboardingScreen', () {
    // ONBOARD-HAPPY-001: Initial render shows first step (welcome).
    testWidgets('shows welcome content on initial render', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OnboardingScreen(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: onboardingWelcomeTitle -> "Welcome to Kusuridoki"
      expect(find.text('Welcome to Kusuridoki'), findsOneWidget);
    });

    // ONBOARD-HAPPY-001: Progress indicator is present on initial render.
    testWidgets('shows progress indicator on initial render', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OnboardingScreen(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingProgressIndicator), findsOneWidget);
    });

    // Step advance: tapping Next advances away from the welcome step.
    testWidgets('tapping Next on welcome step advances to role step', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OnboardingScreen(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      // l10n: onboardingNext -> "Next"
      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      // Welcome title is gone after advancing.
      expect(find.text('Welcome to Kusuridoki'), findsNothing);
    });

    // Progress indicator reflects step state after advancing.
    testWidgets('progress indicator reflects step advancement', (tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          const OnboardingScreen(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      final progressBefore = tester.widget<OnboardingProgressIndicator>(
        find.byType(OnboardingProgressIndicator),
      );
      expect(progressBefore.currentStep, equals(0));

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      final progressAfter = tester.widget<OnboardingProgressIndicator>(
        find.byType(OnboardingProgressIndicator),
      );
      expect(progressAfter.currentStep, equals(1));
    });

    testWidgets('renders without errors in Japanese locale', (tester) async {
      await tester.pumpWidget(
        createTestableWidgetJa(
          const OnboardingScreen(),
          overrides: _overrides(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(OnboardingProgressIndicator), findsOneWidget);
    });
  });
}
