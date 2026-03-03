import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/user_profile.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz_lib;

void main() {
  late ProviderContainer container;

  setUp(() {
    tz.initializeTimeZones();
    // Explicitly set local timezone so tests are deterministic regardless of
    // what other test files do to global tz state (e.g. reminder_provider_test
    // resets tz.local to UTC via initializeTimeZones).
    tz_lib.setLocalLocation(tz_lib.getLocation('America/New_York'));
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('TimezoneSettings', () {
    test('initial state has correct defaults', () {
      final state = container.read(timezoneSettingsProvider);

      expect(state.enabled, isFalse);
      expect(state.mode, TimezoneMode.fixedInterval);
      expect(state.homeTimezone, 'America/New_York');
      expect(state.currentTimezone, 'America/New_York');
    });

    test('toggleEnabled flips enabled from false to true', () {
      container.read(timezoneSettingsProvider.notifier).toggleEnabled();

      final state = container.read(timezoneSettingsProvider);
      expect(state.enabled, isTrue);
    });

    test('toggleEnabled flips enabled from true to false', () {
      final notifier = container.read(timezoneSettingsProvider.notifier);
      notifier.toggleEnabled(); // false -> true
      notifier.toggleEnabled(); // true -> false

      final state = container.read(timezoneSettingsProvider);
      expect(state.enabled, isFalse);
    });

    test('toggleEnabled preserves other fields', () {
      final notifier = container.read(timezoneSettingsProvider.notifier);
      notifier.setMode(TimezoneMode.localTime);
      notifier.setHomeTimezone('Asia/Tokyo');
      notifier.setCurrentTimezone('Europe/London');

      notifier.toggleEnabled();

      final state = container.read(timezoneSettingsProvider);
      expect(state.enabled, isTrue);
      expect(state.mode, TimezoneMode.localTime);
      expect(state.homeTimezone, 'Asia/Tokyo');
      expect(state.currentTimezone, 'Europe/London');
    });

    test('setMode updates mode only', () {
      container
          .read(timezoneSettingsProvider.notifier)
          .setMode(TimezoneMode.localTime);

      final state = container.read(timezoneSettingsProvider);
      expect(state.mode, TimezoneMode.localTime);
      expect(state.enabled, isFalse);
      expect(state.homeTimezone, 'America/New_York');
    });

    test('setHomeTimezone updates homeTimezone only', () {
      container
          .read(timezoneSettingsProvider.notifier)
          .setHomeTimezone('Asia/Tokyo');

      final state = container.read(timezoneSettingsProvider);
      expect(state.homeTimezone, 'Asia/Tokyo');
      expect(state.currentTimezone, 'America/New_York');
    });

    test('setCurrentTimezone updates currentTimezone only', () {
      container
          .read(timezoneSettingsProvider.notifier)
          .setCurrentTimezone('Europe/London');

      final state = container.read(timezoneSettingsProvider);
      expect(state.currentTimezone, 'Europe/London');
      expect(state.homeTimezone, 'America/New_York');
    });

    test('multiple updates accumulate correctly', () {
      final notifier = container.read(timezoneSettingsProvider.notifier);
      notifier.toggleEnabled();
      notifier.setMode(TimezoneMode.localTime);
      notifier.setHomeTimezone('Asia/Tokyo');
      notifier.setCurrentTimezone('Europe/Berlin');

      final state = container.read(timezoneSettingsProvider);
      expect(state.enabled, isTrue);
      expect(state.mode, TimezoneMode.localTime);
      expect(state.homeTimezone, 'Asia/Tokyo');
      expect(state.currentTimezone, 'Europe/Berlin');
    });
  });

  group('TimezoneSettings tracks userSettings homeTimezone via ref.listen', () {
    late ProviderContainer testContainer;

    setUp(() async {
      testContainer = ProviderContainer(
        overrides: [userSettingsProvider.overrideWith(_FakeUserSettings.new)],
      );
      addTearDown(testContainer.dispose);
      await testContainer.read(userSettingsProvider.future);
    });

    test('homeTimezone updates when profile changes, preserving travel mode state',
        () async {
      // Configure travel mode state
      final notifier = testContainer.read(timezoneSettingsProvider.notifier);
      notifier.toggleEnabled();
      notifier.setMode(TimezoneMode.localTime);
      notifier.setCurrentTimezone('Europe/Berlin');

      var state = testContainer.read(timezoneSettingsProvider);
      expect(state.homeTimezone, 'America/New_York');

      // Update profile — only homeTimezone changes
      await testContainer
          .read(userSettingsProvider.notifier)
          .updateProfile(const UserProfile(id: 'test', homeTimezone: 'Asia/Tokyo'));

      state = testContainer.read(timezoneSettingsProvider);
      expect(state.homeTimezone, 'Asia/Tokyo');
      expect(state.enabled, isTrue);
      expect(state.mode, TimezoneMode.localTime);
      expect(state.currentTimezone, 'Europe/Berlin');
    });

    test('unrelated profile changes do not reset travel mode state', () async {
      final notifier = testContainer.read(timezoneSettingsProvider.notifier);
      notifier.toggleEnabled();
      notifier.setCurrentTimezone('Europe/Berlin');

      // Update profile: homeTimezone unchanged, name changes
      await testContainer.read(userSettingsProvider.notifier).updateProfile(
            const UserProfile(
              id: 'test',
              homeTimezone: 'America/New_York',
              name: 'Alice',
            ),
          );

      final state = testContainer.read(timezoneSettingsProvider);
      expect(state.enabled, isTrue);
      expect(state.homeTimezone, 'America/New_York');
      expect(state.currentTimezone, 'Europe/Berlin');
    });
  });
}

/// Fake UserSettings notifier — returns a fixed profile without touching storage.
class _FakeUserSettings extends UserSettings {
  @override
  Future<UserProfile> build() async =>
      const UserProfile(id: 'test', homeTimezone: 'America/New_York');

  @override
  Future<void> updateProfile(UserProfile profile) async {
    state = AsyncData(profile);
  }
}
