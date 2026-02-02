import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/reminder_status.dart';
import 'package:my_pill/data/providers/reminder_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/screens/home/widgets/timeline_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_empty_state.dart';

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

  String _getBadgeLabel(ReminderStatus status) {
    switch (status) {
      case ReminderStatus.taken:
        return 'Taken';
      case ReminderStatus.skipped:
        return 'Skipped';
      case ReminderStatus.missed:
        return 'Missed';
      case ReminderStatus.snoozed:
        return 'Snoozed';
      case ReminderStatus.pending:
        return 'Upcoming';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remindersAsync = ref.watch(todayRemindersProvider);

    return remindersAsync.when(
      data: (reminders) {
        if (reminders.isEmpty) {
          return const MpEmptyState(
            icon: Icons.calendar_today,
            title: 'No reminders for today',
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

                  return medicationAsync.when(
                    data: (medication) {
                      if (medication == null) {
                        return const SizedBox.shrink();
                      }

                      return TimelineCard(
                        medicationName: medication.name,
                        dosage: '${medication.dosage}${medication.dosageUnit.label}',
                        time: DateFormat('h:mm a').format(reminders[i].scheduledTime),
                        badgeVariant: _getBadgeVariant(reminders[i].status),
                        badgeLabel: _getBadgeLabel(reminders[i].status),
                        pillShape: medication.shape,
                        pillColor: medication.color,
                        medicationId: medication.id,
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
            'Error loading reminders',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}
