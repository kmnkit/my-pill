import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/screens/home/widgets/timeline_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_empty_state.dart';
import 'package:kusuridoki/presentation/shared/dialogs/kd_reminder_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

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
          return KdEmptyState(
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
                  final medicationAsync = ref.watch(
                    medicationProvider(reminders[i].medicationId),
                  );
                  final schedulesAsync = ref.watch(
                    medicationSchedulesProvider(reminders[i].medicationId),
                  );

                  return medicationAsync.when(
                    data: (medication) {
                      if (medication == null) {
                        return const SizedBox.shrink();
                      }

                      final reminder = reminders[i];
                      final dosageTimingLabel = schedulesAsync.whenOrNull(
                        data: (schedules) {
                          if (schedules.isEmpty) return null;
                          final timings = schedules.first.dosageTimings;
                          if (timings.isEmpty) return null;

                          // Match reminder's scheduledTime to the specific timing
                          final hour = reminder.scheduledTime.hour;
                          final minute = reminder.scheduledTime.minute;
                          final matched = timings
                              .where((t) => t.isTimeInRange(hour, minute))
                              .map((t) => t.localizedName(l10n))
                              .toList();

                          // If matched, show only the relevant timing; otherwise fallback to all
                          if (matched.isNotEmpty) {
                            return matched.join('・');
                          }
                          return timings
                              .map((t) => t.localizedName(l10n))
                              .join('・');
                        },
                      );

                      return TimelineCard(
                        medicationName: medication.name,
                        dosage:
                            '${medication.dosage}${medication.dosageUnit.localizedName(l10n)}',
                        time: DateFormat(
                          'h:mm a',
                        ).format(reminder.scheduledTime),
                        badgeVariant: _getBadgeVariant(reminder.status),
                        badgeLabel: _getBadgeLabel(reminder.status, l10n),
                        pillShape: medication.shape,
                        pillColor: medication.color,
                        medicationId: medication.id,
                        reminderStatus: reminder.status,
                        onMarkTaken: reminder.status == ReminderStatus.pending
                            ? () async {
                                if (!context.mounted) return;
                                final action = await KdReminderDialog.show(
                                  context,
                                  time: DateFormat('h:mm a')
                                      .format(reminder.scheduledTime),
                                  medicationName: medication.name,
                                  dosage:
                                      '${medication.dosage}${medication.dosageUnit.localizedName(l10n)}',
                                );
                                if (action == null) return;
                                if (!context.mounted) return;
                                final notifier = ref.read(
                                  todayRemindersProvider.notifier,
                                );
                                switch (action) {
                                  case ReminderAction.take:
                                    await notifier.markAsTaken(reminder.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.markedAsTaken(
                                              medication.name,
                                            ),
                                          ),
                                          backgroundColor: AppColors.success,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  case ReminderAction.skip:
                                    await notifier.markAsSkipped(reminder.id);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.markedAsSkipped(
                                              medication.name,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  case ReminderAction.snooze:
                                    await notifier.snooze(
                                      reminder.id,
                                      const Duration(minutes: 15),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            l10n.snoozedReminder(
                                              medication.name,
                                            ),
                                          ),
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                }
                              }
                            : null,
                        dosageTimingLabel: dosageTimingLabel,
                        isCritical: medication.isCritical,
                      );
                    },
                    loading: () => const KdShimmerBox(height: 80),
                    error: (error, stack) => const SizedBox.shrink(),
                  );
                },
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: KdListShimmer(itemCount: 3, itemHeight: 80),
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
