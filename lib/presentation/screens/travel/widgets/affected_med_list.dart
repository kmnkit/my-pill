import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';
import 'package:my_pill/presentation/shared/widgets/mp_pill_icon.dart';

class AffectedMedList extends StatelessWidget {
  const AffectedMedList({super.key});

  @override
  Widget build(BuildContext context) {
    final medications = [
      {'name': 'Vitamin D', 'jst': '10:00 PM', 'est': '8:00 AM'},
      {'name': 'Omega-3', 'jst': '8:00 AM', 'est': '6:00 PM'},
      {'name': 'Melatonin', 'jst': '11:00 PM', 'est': '9:00 AM'},
    ];

    return Column(
      children: medications.map((med) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: MpCard(
            child: Row(
              children: [
                MpPillIcon(
                  shape: PillShape.capsule,
                  color: PillColor.blue,
                  size: AppSpacing.iconMd,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        med['name']!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${med['jst']} JST / ${med['est']} EST',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
