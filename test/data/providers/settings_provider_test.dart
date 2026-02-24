import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/data/services/storage_service.dart';

@GenerateMocks([StorageService])
import 'settings_provider_test.mocks.dart';

void main() {
  late MockStorageService mockStorage;

  setUp(() {
    mockStorage = MockStorageService();
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(mockStorage),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('UserSettings provider', () {
    test('returns default profile when no saved profile exists', () async {
      when(mockStorage.getUserProfile()).thenAnswer((_) async => null);

      final container = makeContainer();
      final result = await container.read(userSettingsProvider.future);

      expect(result.id, equals('local'));
      expect(result.language, equals('en'));
      expect(result.highContrast, isFalse);
      expect(result.textSize, equals('normal'));
      expect(result.notificationsEnabled, isTrue);
      expect(result.snoozeDuration, equals(15));
      expect(result.removeAds, isFalse);
      expect(result.onboardingComplete, isFalse);
    });

    test('returns saved profile when one exists and onboardingComplete is true',
        () async {
      const profile = UserProfile(
        id: 'user-123',
        name: 'Taro',
        language: 'ja',
        highContrast: true,
        textSize: 'large',
        notificationsEnabled: false,
        criticalAlerts: false,
        snoozeDuration: 30,
        travelModeEnabled: false,
        removeAds: true,
        onboardingComplete: true,
      );
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);

      final container = makeContainer();
      final result = await container.read(userSettingsProvider.future);

      expect(result.id, equals('user-123'));
      expect(result.name, equals('Taro'));
      expect(result.language, equals('ja'));
      expect(result.highContrast, isTrue);
      expect(result.removeAds, isTrue);
      expect(result.onboardingComplete, isTrue);
    });

    test('migrates profile when onboardingComplete is false', () async {
      const profile = UserProfile(
        id: 'old-user',
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
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      final result = await container.read(userSettingsProvider.future);

      expect(result.onboardingComplete, isTrue);
      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.onboardingComplete)),
      )).called(1);
    });

    test('updateProfile saves profile and updates state', () async {
      when(mockStorage.getUserProfile()).thenAnswer((_) async => null);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);

      const updated = UserProfile(
        id: 'local',
        name: 'NewName',
        language: 'ja',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
      );

      await container.read(userSettingsProvider.notifier).updateProfile(updated);

      verify(mockStorage.saveUserProfile(updated)).called(1);
      final state = await container.read(userSettingsProvider.future);
      expect(state.name, equals('NewName'));
    });

    test('updateLanguage updates language field', () async {
      const profile = UserProfile(
        id: 'local',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);
      await container.read(userSettingsProvider.notifier).updateLanguage('ja');

      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.language == 'ja')),
      )).called(1);
    });

    test('toggleHighContrast flips highContrast value', () async {
      const profile = UserProfile(
        id: 'local',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);
      await container.read(userSettingsProvider.notifier).toggleHighContrast();

      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.highContrast == true)),
      )).called(1);
    });

    test('updateSnoozeDuration updates snooze duration', () async {
      const profile = UserProfile(
        id: 'local',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);
      await container
          .read(userSettingsProvider.notifier)
          .updateSnoozeDuration(30);

      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.snoozeDuration == 30)),
      )).called(1);
    });

    test('completeOnboarding sets onboardingComplete to true', () async {
      const profile = UserProfile(
        id: 'local',
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
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);
      await container.read(userSettingsProvider.notifier).completeOnboarding();

      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.onboardingComplete == true)),
      )).called(greaterThanOrEqualTo(1));
    });

    test('updateName updates name field', () async {
      const profile = UserProfile(
        id: 'local',
        language: 'en',
        highContrast: false,
        textSize: 'normal',
        notificationsEnabled: true,
        criticalAlerts: false,
        snoozeDuration: 15,
        travelModeEnabled: false,
        removeAds: false,
        onboardingComplete: true,
      );
      when(mockStorage.getUserProfile()).thenAnswer((_) async => profile);
      when(mockStorage.saveUserProfile(any)).thenAnswer((_) async {});

      final container = makeContainer();
      await container.read(userSettingsProvider.future);
      await container.read(userSettingsProvider.notifier).updateName('Hanako');

      verify(mockStorage.saveUserProfile(
        argThat(predicate<UserProfile>((p) => p.name == 'Hanako')),
      )).called(1);
    });
  });
}
