import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class InventoryEditor extends StatelessWidget {
  const InventoryEditor({
    super.key,
    required this.count,
    required this.onCountChanged,
  });

  final int count;
  final ValueChanged<int> onCountChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: count > 0 ? AppColors.primary : AppColors.textMuted,
            iconSize: AppSpacing.iconLg,
            onPressed: count > 0 ? () => onCountChanged(count - 1) : null,
          ),
          const SizedBox(width: AppSpacing.xl),
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: AppSpacing.xl),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColors.primary,
            iconSize: AppSpacing.iconLg,
            onPressed: () => onCountChanged(count + 1),
          ),
        ],
      ),
    );
  }
}
