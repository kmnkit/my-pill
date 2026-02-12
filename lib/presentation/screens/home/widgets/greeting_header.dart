import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class GreetingHeader extends ConsumerWidget {
  const GreetingHeader({super.key});

  String _getGreeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final userSettings = ref.watch(userSettingsProvider);
    final reminders = ref.watch(todayRemindersProvider);

    // Format date using intl (locale-aware)
    final formattedDate = DateFormat.MMMd(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting with optional name
        userSettings.when(
          data: (profile) {
            final greeting = _getGreeting(l10n);
            // Only append name if it's not the default "User"
            final displayText = profile.name != 'User'
                ? '$greeting, ${profile.name}'
                : greeting;
            return Text(displayText, style: textTheme.headlineLarge);
          },
          loading: () => Text(
            _getGreeting(l10n),
            style: textTheme.headlineLarge,
          ),
          error: (error, stackTrace) => Text(
            _getGreeting(l10n),
            style: textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formattedDate,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
        const SizedBox(height: AppSpacing.xs),
        // Medication count
        reminders.when(
          data: (reminderList) {
            final total = reminderList.length;
            final taken = reminderList
                .where((r) => r.status == ReminderStatus.taken)
                .length;
            return Text(
              l10n.medicationsToday(total, taken),
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (error, stackTrace) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
