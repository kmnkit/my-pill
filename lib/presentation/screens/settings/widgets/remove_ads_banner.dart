import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class RemoveAdsBanner extends StatelessWidget {
  const RemoveAdsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MpCard(
      color: AppColors.primary.withValues(alpha: 0.1),
      borderColor: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.diamond, size: AppSpacing.iconLg, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Upgrade for a cleaner experience',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.primary,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          MpButton(
            label: 'Remove Ads',
            onPressed: () {},
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
