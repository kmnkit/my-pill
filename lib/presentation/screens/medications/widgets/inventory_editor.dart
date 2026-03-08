import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class InventoryEditor extends StatelessWidget {
  const InventoryEditor({
    super.key,
    required this.count,
    required this.onCountChanged,
  });

  final int count;
  final ValueChanged<int> onCountChanged;

  Future<void> _showNumberInput(BuildContext context, AppLocalizations l10n) async {
    final controller = TextEditingController(text: count.toString());
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          style: Theme.of(ctx).textTheme.headlineMedium?.copyWith(
            color: AppColors.primary,
          ),
          decoration: InputDecoration(suffix: Text(l10n.inventoryUnitDoses)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              Navigator.of(ctx).pop(value);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null) onCountChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

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
            color: count > 0 ? AppColors.primary : context.appColors.textMuted,
            iconSize: AppSpacing.iconLg,
            onPressed: count > 0 ? () => onCountChanged(count - 1) : null,
          ),
          const SizedBox(width: AppSpacing.xl),
          GestureDetector(
            onTap: () => _showNumberInput(context, l10n),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count.toString(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  l10n.inventoryUnitDoses,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
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
