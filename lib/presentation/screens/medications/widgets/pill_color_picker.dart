import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
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
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: PillColor.values.map((pillColor) {
        return MpColorDot(
          color: pillColor.color,
          isSelected: pillColor == selectedColor,
          onTap: () => onColorSelected(pillColor),
          size: 44,
        );
      }).toList(),
    );
  }
}
