import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

class TimezoneModeSelector extends StatefulWidget {
  const TimezoneModeSelector({super.key});

  @override
  State<TimezoneModeSelector> createState() => _TimezoneModeSelectorState();
}

class _TimezoneModeSelectorState extends State<TimezoneModeSelector> {
  TimezoneMode _selectedMode = TimezoneMode.fixedInterval;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.fixedInterval,
          groupValue: _selectedMode,
          onChanged: (value) {
            setState(() => _selectedMode = value);
          },
          icon: Icons.home,
          label: 'Fixed Interval (Home Time)',
          description: 'Take meds at home timezone',
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.localTime,
          groupValue: _selectedMode,
          onChanged: (value) {
            setState(() => _selectedMode = value);
          },
          icon: Icons.wb_sunny,
          label: 'Local Time Adaptation',
          description: 'Adjust to local timezone',
        ),
      ],
    );
  }
}
