import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/enums/dosage_timing.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class DosageTimingSelector extends StatelessWidget {
  const DosageTimingSelector({
    super.key,
    required this.selectedSlots,
    required this.onChanged,
  });

  final List<DosageTimeSlot> selectedSlots;
  final ValueChanged<List<DosageTimeSlot>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: DosageTiming.values.map((timing) {
        final isSelected = selectedSlots.any((s) => s.timing == timing);
        final borderColor = isSelected
            ? AppColors.primary
            : (isDark ? AppColors.borderDark : AppColors.borderLight);
        return FilterChip(
          label: Text(timing.localizedName(l10n)),
          selected: isSelected,
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          selectedColor: AppColors.primaryLight,
          checkmarkColor: AppColors.primary,
          side: BorderSide(color: borderColor, width: isSelected ? 1.5 : 1),
          labelStyle: TextStyle(
            color: isSelected
                ? AppColors.primary
                : context.appColors.textMuted,
          ),
          onSelected: (selected) {
            final updated = List<DosageTimeSlot>.from(selectedSlots);
            if (selected) {
              updated.add(DosageTimeSlot.withDefault(timing));
            } else {
              updated.removeWhere((s) => s.timing == timing);
            }
            updated.sort((a, b) => a.timing.index.compareTo(b.timing.index));
            onChanged(updated);
          },
        );
      }).toList(),
    );
  }
}
