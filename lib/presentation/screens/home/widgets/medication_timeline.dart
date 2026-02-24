import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/screens/home/widgets/timeline_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class MedicationTimeline extends ConsumerWidget {
  const MedicationTimeline({super.key});

  MpBadgeVariant _getBadgeVariant(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.taken:
        return MpBadgeVariant.taken;
      case ReminderStatus.skipped:
      case ReminderStatus.missed:
        return MpBadgeVariant.missed;
      case ReminderStatus.snoozed:
        return MpBadgeVariant.upcoming;
      case ReminderStatus.pending:
        return MpBadgeVariant.upcoming;
    }
  }

  String _getBadgeLabel(ReminderStatus status, AppLocalizations l10n) {
    switch (status) {
      case ReminderStatus.taken:
        return l10n.taken;
      case ReminderStatus.skipped:
        return l10n.skipped;
      case ReminderStatus.missed:
        return l10n.missed;
      case ReminderStatus.snoozed:
        return l10n.snoozed;
      case ReminderStatus.pending:
        return l10n.upcoming;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final remindersAsync = ref.watch(todayRemindersProvider);

    return remindersAsync.when(
      data: (reminders) {
        if (reminders.isEmpty) {
          return MpEmptyState(
            icon: Icons.calendar_today,
            title: l10n.noRemindersForToday,
          );
        }

        // Build timeline cards with medication data
        return Column(
          children: [
            for (int i = 0; i < reminders.length; i++) ...[
              if (i > 0) const SizedBox(height: AppSpacing.md),
              Consumer(
                builder: (context, ref, _) {
                  final medicationAsync = ref.watch(medicationProvider(reminders[i].medicationId));
                  final schedulesAsync = ref.watch(medicationSchedulesProvider(reminders[i].medicationId));

                  return medicationAsync.when(
                    data: (medication) {
                      if (medication == null) {
                        return const SizedBox.shrink();
                      }

                      final reminder = reminders[i];
                      final dosageTimingLabel = schedulesAsync.whenOrNull(
                        data: (schedules) {
                          if (schedules.isEmpty) return null;
                          final timing = schedules.first.dosageTiming;
                          return timing?.localizedName(l10n);
                        },
                      );

                      return TimelineCard(
                        medicationName: medication.name,
                        dosage: '${medication.dosage}${medication.dosageUnit.localizedName(l10n)}',
                        time: DateFormat('h:mm a').format(reminder.scheduledTime),
                        badgeVariant: _getBadgeVariant(reminder.status),
                        badgeLabel: _getBadgeLabel(reminder.status, l10n),
                        pillShape: medication.shape,
                        pillColor: medication.color,
                        medicationId: medication.id,
                        reminderStatus: reminder.status,
                        onMarkTaken: reminder.status == ReminderStatus.pending
                            ? () => ref.read(todayRemindersProvider.notifier).markAsTaken(reminder.id)
                            : null,
                        dosageTimingLabel: dosageTimingLabel,
                      );
                    },
                    loading: () => const SizedBox(
                      height: 80,
                      child: Center(child: CircularProgressIndicator.adaptive()),
                    ),
                    error: (error, stack) => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ],
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Text(
            l10n.errorLoadingReminders,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
