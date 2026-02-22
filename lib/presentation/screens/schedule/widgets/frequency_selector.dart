import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_radio_option.dart';

class FrequencySelector extends StatelessWidget {
  const FrequencySelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  final ScheduleType selectedType;
  final ValueChanged<ScheduleType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MpRadioOption<ScheduleType>(
          value: ScheduleType.daily,
          groupValue: selectedType,
          onChanged: onChanged,
          label: l10n.daily,
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: AppSpacing.sm),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.specificDays,
          groupValue: selectedType,
          onChanged: onChanged,
          label: l10n.specificDays,
          icon: Icons.event_repeat,
        ),
        const SizedBox(height: AppSpacing.sm),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.interval,
          groupValue: selectedType,
          onChanged: onChanged,
          label: l10n.interval,
          icon: Icons.history,
        ),
      ],
    );
  }
}
