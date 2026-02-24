import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/dosage_timing.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class DosageTimingSelector extends StatelessWidget {
  const DosageTimingSelector({
    super.key,
    required this.selectedTiming,
    required this.onChanged,
  });

  final DosageTiming? selectedTiming;
  final ValueChanged<DosageTiming?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: DosageTiming.values.map((timing) {
        final isSelected = selectedTiming == timing;
        return ChoiceChip(
          label: Text(timing.localizedName(l10n)),
          selected: isSelected,
          onSelected: (selected) {
            onChanged(selected ? timing : null);
          },
        );
      }).toList(),
    );
  }
}
