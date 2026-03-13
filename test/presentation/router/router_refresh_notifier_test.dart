// SC-RTR-001 through SC-RTR-002
// Tests for RouterRefreshNotifier: update and updateAuth change detection
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/presentation/router/app_router_provider.dart';

void main() {
  // ---------------------------------------------------------------------------
  // SC-RTR-001: update notifies only when onboardingComplete or userRole changes
  // ---------------------------------------------------------------------------
  group('RouterRefreshNotifier.update — SC-RTR-001', () {
    test('notifies listener when settings change from null to a value', () {
      final notifier = RouterRefreshNotifier();
      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      final settings = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: false,
        userRole: 'patient',
      );
      notifier.update(settings);

      expect(notifyCount, equals(1),
          reason: 'should notify on null -> value change');
    });

    test('does NOT notify when same value is applied again', () {
      final notifier = RouterRefreshNotifier();
      final settings = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: false,
        userRole: 'patient',
      );
      notifier.update(settings); // first call — notifies

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.update(settings); // same value — should NOT notify
      expect(notifyCount, equals(0),
          reason: 'should NOT notify when nothing changed');
    });

    test('notifies when onboardingComplete changes from false to true', () {
      final notifier = RouterRefreshNotifier();
      final initial = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: false,
        userRole: 'patient',
      );
      notifier.update(initial); // sets initial state

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      final updated = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: true,
        userRole: 'patient',
      );
      notifier.update(updated);

      expect(notifyCount, equals(1),
          reason: 'should notify when onboardingComplete changes');
    });

    test('notifies when userRole changes', () {
      final notifier = RouterRefreshNotifier();
      final initial = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: true,
        userRole: 'patient',
      );
      notifier.update(initial);

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      final updated = const UserProfile(
        id: 'u1',
        name: 'Test',
        onboardingComplete: true,
        isCaregiver: true,
      );
      notifier.update(updated);

      expect(notifyCount, equals(1),
          reason: 'should notify when isCaregiver changes');
    });

    test('does NOT notify when only name changes (irrelevant field)', () {
      final notifier = RouterRefreshNotifier();
      final initial = const UserProfile(
        id: 'u1',
        name: 'Alice',
        onboardingComplete: true,
        userRole: 'patient',
      );
      notifier.update(initial);

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      final updated = const UserProfile(
        id: 'u1',
        name: 'Bob', // only name changed
        onboardingComplete: true,
        userRole: 'patient',
      );
      notifier.update(updated);

      expect(notifyCount, equals(0),
          reason:
              'should NOT notify when only non-routing fields change');
    });
  });

  // ---------------------------------------------------------------------------
  // SC-RTR-002: updateAuth notifies only when isAuthenticated changes
  // ---------------------------------------------------------------------------
  group('RouterRefreshNotifier.updateAuth — SC-RTR-002', () {
    test('notifies when isAuthenticated changes from false to true', () {
      final notifier = RouterRefreshNotifier();
      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.updateAuth(true);
      expect(notifyCount, equals(1));
    });

    test('does NOT notify when isAuthenticated stays the same (true -> true)',
        () {
      final notifier = RouterRefreshNotifier();
      notifier.updateAuth(true); // set to true

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.updateAuth(true); // same value
      expect(notifyCount, equals(0));
    });

    test('notifies when isAuthenticated changes from true to false', () {
      final notifier = RouterRefreshNotifier();
      notifier.updateAuth(true);

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.updateAuth(false);
      expect(notifyCount, equals(1));
    });

    test('does NOT notify when isAuthenticated stays false (false -> false)',
        () {
      final notifier = RouterRefreshNotifier();
      // Default is false, so no need to set

      var notifyCount = 0;
      notifier.addListener(() => notifyCount++);

      notifier.updateAuth(false);
      expect(notifyCount, equals(0));
    });
  });
}
