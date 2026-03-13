import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';

/// Invalidate all user-data providers during sign-out or account deletion.
///
/// Must be called BEFORE signOut() so router redirect sees stale-free state.
void invalidateUserProviders(WidgetRef ref) {
  ref.invalidate(medicationListProvider);
  ref.invalidate(scheduleListProvider);
  ref.invalidate(todayRemindersProvider);
  ref.invalidate(overallAdherenceProvider);
  ref.invalidate(weeklyAdherenceProvider);
  ref.invalidate(caregiverLinksProvider);
  ref.invalidate(userSettingsProvider);
}
