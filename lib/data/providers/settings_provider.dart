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
    return profile ?? const UserProfile(
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
}
