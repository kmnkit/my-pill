import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/shared/widgets/mp_color_dot.dart';

class PillColorPicker extends StatelessWidget {
  const PillColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final PillColor selectedColor;
  final ValueChanged<PillColor> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: PillColor.values.map((pillColor) {
        return MpColorDot(
          color: pillColor.color,
          isSelected: pillColor == selectedColor,
          onTap: () => onColorSelected(pillColor),
          size: 44,
          colorLabel: pillColor.localizedName(l10n),
        );
      }).toList(),
    );
  }
}
