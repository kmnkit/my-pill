import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_time_picker.dart';

class DosageTimeAdjuster extends StatelessWidget {
  const DosageTimeAdjuster({
    super.key,
    required this.slots,
    required this.onSlotsChanged,
  });

  final List<DosageTimeSlot> slots;
  final ValueChanged<List<DosageTimeSlot>> onSlotsChanged;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final sorted = List<DosageTimeSlot>.from(slots)
      ..sort((a, b) => a.timing.index.compareTo(b.timing.index));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: sorted.map((slot) {
        final timing = slot.timing;
        final tod = slot.timeOfDay;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timing.localizedName(l10n),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              KdTimePicker(
                hour: tod.hour,
                minute: tod.minute,
                onHourChanged: (newHour) {
                  _onHourChanged(slot, newHour, tod.minute);
                },
                onMinuteChanged: (newMinute) {
                  _onMinuteChanged(slot, tod.hour, newMinute);
                },
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.timeRangeHint(
                  timing.localizedName(l10n),
                  timing.minHour.toString().padLeft(2, '0'),
                  timing.maxHour.toString().padLeft(2, '0'),
                ),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _onHourChanged(DosageTimeSlot slot, int newHour, int currentMinute) {
    final timing = slot.timing;
    int clampedHour = newHour;

    if (!timing.isTimeInRange(newHour, currentMinute)) {
      if (timing.minHour <= timing.maxHour) {
        // Normal range
        clampedHour =
            (newHour - timing.minHour).abs() <= (newHour - timing.maxHour).abs()
            ? timing.minHour
            : timing.maxHour;
      } else {
        // Wrap-around (bedtime): minHour=21, maxHour=1
        if (newHour > timing.maxHour && newHour < timing.minHour) {
          final distToMin = timing.minHour - newHour;
          final distToMax = newHour - timing.maxHour;
          clampedHour = distToMax <= distToMin
              ? timing.maxHour
              : timing.minHour;
        }
      }
    }

    final timeStr =
        '${clampedHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}';
    _updateSlot(slot, timeStr);
  }

  void _onMinuteChanged(DosageTimeSlot slot, int currentHour, int newMinute) {
    final timeStr =
        '${currentHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}';
    _updateSlot(slot, timeStr);
  }

  void _updateSlot(DosageTimeSlot oldSlot, String newTime) {
    final updated = slots.map((s) {
      if (s.timing == oldSlot.timing) {
        return s.copyWith(time: newTime);
      }
      return s;
    }).toList();
    onSlotsChanged(updated);
  }
}
