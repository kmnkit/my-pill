import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/models/caregiver_link.dart';
import 'package:my_pill/presentation/shared/widgets/mp_avatar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_badge.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class CaregiverListTile extends StatelessWidget {
  const CaregiverListTile({
    super.key,
    required this.link,
    this.onRevoke,
  });

  final CaregiverLink link;
  final VoidCallback? onRevoke;

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  MpBadgeVariant _getStatusVariant(String status) {
    switch (status.toLowerCase()) {
      case 'connected':
        return MpBadgeVariant.connected;
      case 'pending':
        return MpBadgeVariant.upcoming;
      default:
        return MpBadgeVariant.connected;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MpCard(
      child: Row(
        children: [
          MpAvatar(initials: _getInitials(link.caregiverName), size: 48.0),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              link.caregiverName,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          MpBadge(
            label: link.status[0].toUpperCase() + link.status.substring(1),
            variant: _getStatusVariant(link.status),
          ),
          const SizedBox(width: AppSpacing.sm),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: AppSpacing.iconMd),
            onSelected: (value) {
              if (value == 'revoke' && onRevoke != null) {
                onRevoke!();
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
