import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

class ScheduleTypeSelector extends StatelessWidget {
  const ScheduleTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  final ScheduleType selectedType;
  final ValueChanged<ScheduleType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MpRadioOption<ScheduleType>(
          value: ScheduleType.daily,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: 'Daily',
          icon: Icons.calendar_today,
          description: 'Take every day at the same time',
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.specificDays,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: 'Specific Days',
          icon: Icons.date_range,
          description: 'Take on selected days of the week',
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.interval,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: 'Interval',
          icon: Icons.schedule,
          description: 'Take every X hours or days',
        ),
      ],
    );
  }
}
