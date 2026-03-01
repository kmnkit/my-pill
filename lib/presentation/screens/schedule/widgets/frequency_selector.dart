import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_radio_option.dart';

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
          description: l10n.dailyDesc,
          icon: Icons.calendar_today,
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.specificDays,
          groupValue: selectedType,
          onChanged: onChanged,
          label: l10n.specificDays,
          description: l10n.specificDaysDesc,
          icon: Icons.event_repeat,
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<ScheduleType>(
          value: ScheduleType.interval,
          groupValue: selectedType,
          onChanged: onChanged,
          label: l10n.interval,
          description: l10n.intervalDesc,
          icon: Icons.history,
        ),
      ],
    );
  }
}
