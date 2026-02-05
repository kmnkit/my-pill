import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/models/user_profile.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';

part 'settings_provider.g.dart';

@riverpod
class UserSettings extends _$UserSettings {
  @override
  Future<UserProfile> build() async {
    final storage = ref.watch(storageServiceProvider);
    final profile = await storage.getUserProfile();

    if (profile != null) {
      // Migration: existing users (who have a saved profile) should be
      // considered as having completed onboarding
      if (!profile.onboardingComplete) {
        final migrated = profile.copyWith(onboardingComplete: true);
        await storage.saveUserProfile(migrated);
        return migrated;
      }
      return profile;
    }

    // New user - onboardingComplete defaults to false
    return const UserProfile(
      id: 'local',
      name: 'User',
      language: 'en',
      highContrast: false,
      textSize: 'normal',
      notificationsEnabled: true,
      criticalAlerts: false,
      snoozeDuration: 15,
      travelModeEnabled: false,
      removeAds: false,
    );
  }

  Future<void> updateProfile(UserProfile profile) async {
    final storage = ref.read(storageServiceProvider);
    await storage.saveUserProfile(profile);
    ref.invalidateSelf();
  }

  Future<void> updateLanguage(String language) async {
    final current = await future;
    final updated = current.copyWith(language: language);
    await updateProfile(updated);
  }

  Future<void> toggleHighContrast() async {
    final current = await future;
    final updated = current.copyWith(highContrast: !current.highContrast);
    await updateProfile(updated);
  }

  Future<void> updateSnoozeDuration(int minutes) async {
    final current = await future;
    final updated = current.copyWith(snoozeDuration: minutes);
    await updateProfile(updated);
  }

  Future<void> toggleTravelMode() async {
    final current = await future;
    final updated = current.copyWith(travelModeEnabled: !current.travelModeEnabled);
    await updateProfile(updated);
  }

  Future<void> updateTextSize(String size) async {
    final current = await future;
    final updated = current.copyWith(textSize: size);
    await updateProfile(updated);
  }

  Future<void> updateName(String name) async {
    final current = await future;
    final updated = current.copyWith(name: name);
    await updateProfile(updated);
  }

  Future<void> updateUserRole(String role) async {
    final current = await future;
    final updated = current.copyWith(userRole: role);
    await updateProfile(updated);
  }

  Future<void> updateHomeTimezone(String timezone) async {
    final current = await future;
    final updated = current.copyWith(homeTimezone: timezone);
    await updateProfile(updated);
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    final current = await future;
    final updated = current.copyWith(notificationsEnabled: enabled);
    await updateProfile(updated);
  }

  Future<void> completeOnboarding() async {
    final current = await future;
    final updated = current.copyWith(onboardingComplete: true);
    await updateProfile(updated);
  }
}
