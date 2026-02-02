import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/data/providers/timezone_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class AffectedMedList extends ConsumerWidget {
  const AffectedMedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationsAsync = ref.watch(medicationListProvider);
    final schedulesAsync = ref.watch(scheduleListProvider);
    final timezoneState = ref.watch(timezoneSettingsProvider);
    final timezoneService = ref.watch(timezoneServiceProvider);
    final timeFormat = DateFormat('h:mm a');

    return medicationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading medications: $error',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
        ),
      ),
      data: (medications) {
        return schedulesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Text(
              'Error loading schedules: $error',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                  ),
            ),
          ),
          data: (schedules) {
            // Filter medications that have active schedules with times
            final medsWithSchedules = <({
              Medication medication,
              Schedule schedule,
              List<({String homeTime, String localTime})> times,
            })>[];

            for (final med in medications) {
              final medSchedules = schedules
                  .where((s) => s.medicationId == med.id && s.isActive && s.times.isNotEmpty)
                  .toList();

              for (final schedule in medSchedules) {
                final adjustedTimes = <({String homeTime, String localTime})>[];

                for (final timeStr in schedule.times) {
                  try {
                    // Parse time string (HH:mm format)
                    final parts = timeStr.split(':');
                    if (parts.length != 2) continue;

                    final hour = int.parse(parts[0]);
                    final minute = int.parse(parts[1]);

                    // Create DateTime for today with the schedule time
                    final now = DateTime.now();
                    final homeTime = DateTime(now.year, now.month, now.day, hour, minute);

                    // Adjust time based on timezone settings
                    final localTime = timezoneService.adjustMedicationTime(
                      homeTime,
                      timezoneState.homeTimezone,
                      timezoneState.currentTimezone,
                      timezoneState.mode,
                    );

                    adjustedTimes.add((
                      homeTime: timeFormat.format(homeTime),
                      localTime: timeFormat.format(localTime),
                    ));
                  } catch (e) {
                    // Skip invalid time formats
                    continue;
                  }
                }

                if (adjustedTimes.isNotEmpty) {
                  medsWithSchedules.add((
                    medication: med,
                    schedule: schedule,
                    times: adjustedTimes,
                  ));
                }
              }
            }

            if (medsWithSchedules.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Text(
                    'No scheduled medications',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
                  ),
                ),
              );
            }

            // Get timezone labels for display
            String getTimezoneLabel(String timezone) {
              try {
                return timezoneService.formatTimezone(timezone);
              } catch (e) {
                return timezone;
              }
            }

            final homeLabel = getTimezoneLabel(timezoneState.homeTimezone);
            final localLabel = getTimezoneLabel(timezoneState.currentTimezone);

            return Column(
              children: medsWithSchedules.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: MpCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            MpPillIcon(
                              shape: item.medication.shape,
                              color: item.medication.color,
                              size: AppSpacing.iconMd,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                item.medication.name,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...item.times.map((timeInfo) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              '${timeInfo.homeTime} $homeLabel / ${timeInfo.localTime} $localLabel',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
