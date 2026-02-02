import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_avatar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class CaregiverListTile extends StatelessWidget {
  const CaregiverListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return MpCard(
      child: Row(
        children: [
          const MpAvatar(initials: 'YT', size: 48.0),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              'Yuki Tanaka',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const MpBadge(
            label: 'Connected',
            variant: MpBadgeVariant.connected,
          ),
          const SizedBox(width: AppSpacing.sm),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: AppSpacing.iconMd),
            onSelected: (value) {
              if (value == 'revoke') {
                // Handle revoke action
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'revoke',
                child: Row(
                  children: [
                    Icon(Icons.person_remove, size: AppSpacing.iconMd, color: AppColors.error),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Revoke Access',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
