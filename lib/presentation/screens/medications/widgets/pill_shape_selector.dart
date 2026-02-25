import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/theme/app_colors_extension.dart';
import 'package:my_pill/core/extensions/enum_l10n_extensions.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/l10n/app_localizations.dart';

class PillShapeSelector extends StatelessWidget {
  const PillShapeSelector({
    super.key,
    required this.selectedShape,
    required this.onShapeSelected,
  });

  final PillShape selectedShape;
  final ValueChanged<PillShape> onShapeSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 1.2,
      children: PillShape.values.map((shape) {
        final isSelected = shape == selectedShape;
        return Semantics(
          button: true,
          selected: isSelected,
          label: shape.localizedName(l10n),
          child: InkWell(
          onTap: () => onShapeSelected(shape),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLight
                  : (isDark ? AppColors.cardDark : AppColors.cardLight),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: ExcludeSemantics(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    shape.icon,
                    color: isSelected ? AppColors.primary : context.appColors.textMuted,
                    size: AppSpacing.iconLg,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    shape.localizedName(l10n),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected ? AppColors.primary : context.appColors.textMuted,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          ),
        );
      }).toList(),
    );
  }
}
