import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class DosageMultiplier extends StatelessWidget {
  const DosageMultiplier({
    super.key,
    required this.selectedCount,
    required this.onChanged,
  });

  final int selectedCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [1, 2, 3, 4].map((count) {
        final isSelected = count == selectedCount;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: count < 4 ? AppSpacing.sm : 0,
            ),
            child: GestureDetector(
              onTap: () => onChanged(count),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.cardDark : AppColors.cardLight),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${count}x',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? AppColors.textOnPrimary : null,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
