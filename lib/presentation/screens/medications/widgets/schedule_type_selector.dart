import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        MpRadioOption<ScheduleType>(
          value: ScheduleType.daily,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: l10n.daily,
          icon: Icons.calendar_today,
          description: l10n.dailyDesc,
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.specificDays,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: l10n.specificDays,
          icon: Icons.date_range,
          description: l10n.specificDaysDesc,
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.interval,
          groupValue: selectedType,
          onChanged: onTypeSelected,
          label: l10n.interval,
          icon: Icons.schedule,
          description: l10n.intervalDesc,
        ),
      ],
    );
  }
}
