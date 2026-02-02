import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/providers/timezone_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

class TimezoneModeSelector extends ConsumerWidget {
  const TimezoneModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timezoneState = ref.watch(timezoneSettingsProvider);

    return Column(
      children: [
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.fixedInterval,
          groupValue: timezoneState.mode,
          onChanged: (value) {
            ref.read(timezoneSettingsProvider.notifier).setMode(value);
          },
          icon: Icons.home,
          label: 'Fixed Interval (Home Time)',
          description: 'Take meds at home timezone',
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.localTime,
          groupValue: timezoneState.mode,
          onChanged: (value) {
            ref.read(timezoneSettingsProvider.notifier).setMode(value);
          },
          icon: Icons.wb_sunny,
          label: 'Local Time Adaptation',
          description: 'Adjust to local timezone',
        ),
      ],
    );
  }
}
