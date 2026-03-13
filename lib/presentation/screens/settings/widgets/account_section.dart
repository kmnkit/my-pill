import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/auth_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/data/services/auth_service.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_avatar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

class AccountSection extends ConsumerWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);
    final l10n = AppLocalizations.of(context)!;

    return authStateAsync.when(
      loading: () => const KdCard(
        child: KdShimmerBox(height: 56),
      ),
      error: (error, stack) => KdCard(
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                l10n.errorLoadingAccount,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
      data: (user) {
        if (user == null) {
          // No user signed in (should not happen in settings)
          return KdCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const KdAvatar(initials: '?', size: 56.0),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.notSignedIn,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.signInToAccess,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ],
            ),
          );
        }

        final isAnonymous = user.isAnonymous;
        final userProfile = ref.watch(userSettingsProvider).value;
        final profileName = userProfile?.name;
        // Fallback chain: profile name (if not null/empty/legacy 'User') -> Firebase displayName -> email prefix -> guest
        final displayName =
            (profileName != null &&
                profileName.isNotEmpty &&
                profileName != 'User')
            ? profileName
            : (user.displayName ??
                  (user.email?.split('@').first ?? l10n.guestUser));
        final email = userProfile?.email ?? user.email ?? l10n.noEmail;
        final initials = _getInitials(displayName);

        if (isAnonymous) {
          // Anonymous user — tap to go to login screen
          return KdCard(
            onTap: () => _navigateToLogin(context, ref),
            child: Row(
              children: [
                KdAvatar(initials: initials, size: 56.0),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.signInToSync,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: context.appColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.appColors.textMuted,
                ),
              ],
            ),
          );
        }

        // Authenticated user
        final isPrivateEmail = AuthService.isPrivateRelayEmail(user.email);

        return KdCard(
          child: Row(
            children: [
              KdAvatar(initials: initials, size: 56.0),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    if (isPrivateEmail)
                      Text(
                        l10n.emailHidden,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    else
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _navigateToLogin(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(storageServiceProvider).clearUserData();
      await ref.read(authServiceProvider).signOut();
      // Router will redirect to /login automatically via auth state change
    } catch (e) {
      if (context.mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorOccurred),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
