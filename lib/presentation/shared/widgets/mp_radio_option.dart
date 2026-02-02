import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';

class MpRadioOption<T> extends StatelessWidget {
  const MpRadioOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
    this.icon,
    this.description,
  });

  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final String label;
  final IconData? icon;
  final String? description;

  bool get _isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _isSelected
              ? AppColors.primaryLight
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: _isSelected ? AppColors.primary : AppColors.borderLight,
            width: _isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: _isSelected ? AppColors.primary : AppColors.textMuted, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: _isSelected ? AppColors.primary : null,
                  )),
                  if (description != null)
                    Text(description!, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
