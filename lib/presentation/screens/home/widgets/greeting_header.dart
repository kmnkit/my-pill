import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

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
    final streakAsync = ref.watch(adherenceStreakProvider);

    final locale = Localizations.localeOf(context).languageCode;
    // Format date using intl (locale-aware)
    final formattedDate = DateFormat.MMMd(locale).format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting with optional name
        userSettings.when(
          data: (profile) {
            final greeting = _getGreeting(l10n);
            // Only append name if it's non-null, non-empty, and not the default "User"
            final displayText =
                profile.name != null &&
                    profile.name!.isNotEmpty &&
                    profile.name != 'User'
                ? '$greeting, ${profile.name!}'
                : greeting;
            return Text(displayText, style: textTheme.headlineLarge);
          },
          loading: () =>
              Text(_getGreeting(l10n), style: textTheme.headlineLarge),
          error: (_, _) =>
              Text(_getGreeting(l10n), style: textTheme.headlineLarge),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formattedDate,
          style: textTheme.bodyMedium?.copyWith(
            color: context.appColors.textMuted,
          ),
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
              style: textTheme.bodyMedium?.copyWith(
                color: context.appColors.textMuted,
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
        // Next dose info + streak chip
        reminders.when(
          data: (reminderList) {
            if (reminderList.isEmpty) return const SizedBox.shrink();
            final now = DateTime.now();
            final pending = reminderList
                .where(
                  (r) =>
                      r.status == ReminderStatus.pending &&
                      r.scheduledTime.isAfter(now),
                )
                .toList()
              ..sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
            final allDone = reminderList.every(
              (r) =>
                  r.status == ReminderStatus.taken ||
                  r.status == ReminderStatus.skipped,
            );

            Widget? doseWidget;
            if (pending.isNotEmpty) {
              final formattedTime =
                  DateFormat.jm(locale).format(pending.first.scheduledTime);
              doseWidget = Text(
                l10n.nextDoseAt(formattedTime),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                ),
              );
            } else if (allDone) {
              doseWidget = Text(
                l10n.allDoneForToday,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.success,
                ),
              );
            }

            final streakValue = streakAsync.maybeWhen(
              data: (v) => v,
              orElse: () => 0,
            );
            if (doseWidget == null && streakValue == 0) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  ?doseWidget,
                  if (doseWidget != null && streakValue > 0)
                    const SizedBox(width: AppSpacing.md),
                  if (streakValue > 0) _StreakChip(days: streakValue),
                ],
              ),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 3),
          Text(
            l10n.streakDays(days),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
