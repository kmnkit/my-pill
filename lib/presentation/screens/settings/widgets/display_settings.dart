import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/settings_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

// Display label -> stored value (lowercase)
const _textSizeOptions = {
  'Normal': 'normal',
  'Large': 'large',
  'XL': 'xl',
};

// Stored value (lowercase) -> display label
const _textSizeLabels = {
  'normal': 'Normal',
  'large': 'Large',
  'xl': 'XL',
};

class DisplaySettings extends ConsumerWidget {
  const DisplaySettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settingsAsync = ref.watch(userSettingsProvider);

    return settingsAsync.when(
      data: (settings) {
        final highContrast = settings.highContrast;
        final textSize = settings.textSize;
        final textSizeLabel = _textSizeLabels[textSize] ?? 'Normal';

        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MpSectionHeader(title: 'Display'),
        MpToggleSwitch(
          value: highContrast,
          onChanged: (value) {
            ref.read(userSettingsProvider.notifier).toggleHighContrast();
          },
          label: 'High Contrast',
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Text Size',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: ['Normal', 'Large', 'XL'].map((displayLabel) {
            final isSelected = textSizeLabel == displayLabel;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () {
                  final storedValue = _textSizeOptions[displayLabel]!;
                  ref.read(userSettingsProvider.notifier).updateTextSize(storedValue);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.cardDark : AppColors.cardLight),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Text(
                    displayLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.textOnPrimary : null,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
