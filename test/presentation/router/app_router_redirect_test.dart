// Tests for the router redirect logic: SC-RTR-010 through SC-RTR-025
// These tests cover all navigation scenarios for login, logout, and account deletion
// across anonymous, Google, and Apple auth types.
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/presentation/router/app_router_provider.dart';

// ─── Shared test profiles ────────────────────────────────────────────────────

const _patientOnboarded = UserProfile(
  id: 'u1',
  name: 'Alice',
  onboardingComplete: true,
  userRole: 'patient',
);

const _caregiverOnboarded = UserProfile(
  id: 'u2',
  name: 'Bob',
  onboardingComplete: true,
  userRole: 'caregiver',
);

const _notOnboarded = UserProfile(
  id: 'u3',
  name: null,
  onboardingComplete: false,
  userRole: 'patient',
);

// Profile after clearUserData() on sign-out: onboarding preserved, role reset
const _afterSignOut = UserProfile(
  id: '',
  name: null,
  onboardingComplete: true,
  userRole: 'patient',
);

// ─── Tests ───────────────────────────────────────────────────────────────────

void main() {
  group('computeRedirect —', () {
    // ─── Splash always passes through ──────────────────────────────────────

    // SC-RTR-010: Splash route is always allowed through
    test('SC-RTR-010: /splash always returns null', () {
      expect(
        computeRedirect(
          matchedLocation: '/splash',
          isAuthenticated: false,
          currentSettings: null,
          queryParameters: {},
        ),
        isNull,
      );
    });

    test('SC-RTR-010b: /splash passes through even when authenticated', () {
      expect(
        computeRedirect(
          matchedLocation: '/splash',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // ─── Settings null (cold start / loading) ──────────────────────────────

    // SC-RTR-011: No settings + random route → /onboarding
    test('SC-RTR-011: null settings + unknown route → /onboarding', () {
      expect(
        computeRedirect(
          matchedLocation: '/home',
          isAuthenticated: false,
          currentSettings: null,
          queryParameters: {},
        ),
        equals('/onboarding'),
      );
    });

    // SC-RTR-012: No settings + on /onboarding → pass through
    test('SC-RTR-012: null settings + /onboarding → null', () {
      expect(
        computeRedirect(
          matchedLocation: '/onboarding',
          isAuthenticated: false,
          currentSettings: null,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // SC-RTR-013: No settings + on /login → pass through
    test('SC-RTR-013: null settings + /login → null', () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: false,
          currentSettings: null,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // ─── Onboarding not complete ────────────────────────────────────────────

    // SC-RTR-014: Onboarding incomplete + any non-onboarding route → /onboarding
    test('SC-RTR-014: onboarding incomplete + /home → /onboarding', () {
      expect(
        computeRedirect(
          matchedLocation: '/home',
          isAuthenticated: false,
          currentSettings: _notOnboarded,
          queryParameters: {},
        ),
        equals('/onboarding'),
      );
    });

    test('SC-RTR-014b: onboarding incomplete + /settings → /onboarding', () {
      expect(
        computeRedirect(
          matchedLocation: '/settings',
          isAuthenticated: true,
          currentSettings: _notOnboarded,
          queryParameters: {},
        ),
        equals('/onboarding'),
      );
    });

    // SC-RTR-015: Onboarding complete + on /onboarding → /login
    test('SC-RTR-015: onboarding complete + /onboarding → /login', () {
      expect(
        computeRedirect(
          matchedLocation: '/onboarding',
          isAuthenticated: false,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        equals('/login'),
      );
    });

    // ─── Sign-out navigation (RTR-016: THE KEY TEST) ────────────────────────

    // SC-RTR-016: After sign-out (unauthenticated + onboarding complete) → /login
    // This covers: anonymous sign-out, Google sign-out, Apple sign-out
    test(
        'SC-RTR-016: unauthenticated + onboarding complete → /login (sign-out)',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/home',
          isAuthenticated: false,
          currentSettings: _afterSignOut,
          queryParameters: {},
        ),
        equals('/login'),
      );
    });

    test(
        'SC-RTR-016b: unauthenticated + onboarding complete + on /settings → /login',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/settings',
          isAuthenticated: false,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        equals('/login'),
      );
    });

    // SC-RTR-016c: After account deletion → also redirects to /login
    test('SC-RTR-016c: unauthenticated + caregiver profile → /login', () {
      // Even if userRole was caregiver before deletion, unauthenticated → /login
      expect(
        computeRedirect(
          matchedLocation: '/caregiver/patients',
          isAuthenticated: false,
          currentSettings: _caregiverOnboarded,
          queryParameters: {},
        ),
        equals('/login'),
      );
    });

    // ─── Login screen stays when unauthenticated ────────────────────────────

    // SC-RTR-017: Unauthenticated + already on /login → null (stay on login)
    test('SC-RTR-017: unauthenticated + on /login → null', () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: false,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // ─── Login success navigation ───────────────────────────────────────────

    // SC-RTR-018: Authenticated + on /login + patient → /home
    // Covers: anonymous login, Google login (patient), Apple login (patient)
    test('SC-RTR-018: authenticated + /login + patient → /home', () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        equals('/home'),
      );
    });

    // SC-RTR-019: Authenticated + on /login + caregiver → /caregiver/patients
    test(
        'SC-RTR-019: authenticated + /login + caregiver → /caregiver/patients',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: true,
          currentSettings: _caregiverOnboarded,
          queryParameters: {},
        ),
        equals('/caregiver/patients'),
      );
    });

    // ─── Authenticated stays on app screens ────────────────────────────────

    // SC-RTR-020: Authenticated + onboarding complete + on /home → null
    test('SC-RTR-020: authenticated + onboarding complete + /home → null', () {
      expect(
        computeRedirect(
          matchedLocation: '/home',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    test(
        'SC-RTR-020b: authenticated + onboarding complete + /settings → null',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/settings',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    test(
        'SC-RTR-020c: caregiver + /caregiver/patients → null',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/caregiver/patients',
          isAuthenticated: true,
          currentSettings: _caregiverOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // ─── Invite deep links ──────────────────────────────────────────────────

    // SC-RTR-021: Unauthenticated + invite route → /login?redirect=/invite/CODE
    test('SC-RTR-021: unauthenticated + /invite/CODE → /login?redirect=...', () {
      expect(
        computeRedirect(
          matchedLocation: '/invite/abc123',
          isAuthenticated: false,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        equals('/login?redirect=/invite/abc123'),
      );
    });

    // SC-RTR-022: Authenticated + invite route → null (pass through)
    test('SC-RTR-022: authenticated + /invite/CODE → null', () {
      expect(
        computeRedirect(
          matchedLocation: '/invite/abc123',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
        ),
        isNull,
      );
    });

    // SC-RTR-023: Authenticated + /login + redirect query param → that path
    test('SC-RTR-023: authenticated + /login + redirect param → redirect path',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {'redirect': '/invite/abc123'},
        ),
        equals('/invite/abc123'),
      );
    });

    // SC-RTR-024: Authenticated + /login + pending invite code → /invite/CODE
    test('SC-RTR-024: authenticated + /login + pending invite → /invite/CODE',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/login',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
          consumePendingInviteCode: () => 'CODE123',
        ),
        equals('/invite/CODE123'),
      );
    });

    // SC-RTR-025: Authenticated + onboarding complete + NOT on login + pending invite → /invite/CODE
    test(
        'SC-RTR-025: authenticated + on /home + pending invite → /invite/CODE',
        () {
      expect(
        computeRedirect(
          matchedLocation: '/home',
          isAuthenticated: true,
          currentSettings: _patientOnboarded,
          queryParameters: {},
          consumePendingInviteCode: () => 'CODE123',
        ),
        equals('/invite/CODE123'),
      );
    });

    // ─── Invite code consumed for authenticated invite route ───────────────

    test('SC-RTR-022b: authenticated + /invite/CODE consumes pending code', () {
      var consumed = false;
      computeRedirect(
        matchedLocation: '/invite/abc123',
        isAuthenticated: true,
        currentSettings: _patientOnboarded,
        queryParameters: {},
        consumePendingInviteCode: () {
          consumed = true;
          return null;
        },
      );
      expect(consumed, isTrue);
    });
  });
}
