import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/constants/feature_flags.dart';
import 'package:kusuridoki/data/providers/caregiver_monitoring_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/presentation/shared/widgets/premium_gate.dart';
import 'package:kusuridoki/presentation/router/route_names.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';

class InviteHandlerScreen extends ConsumerStatefulWidget {
  const InviteHandlerScreen({super.key, required this.inviteCode});

  final String inviteCode;

  @override
  ConsumerState<InviteHandlerScreen> createState() =>
      _InviteHandlerScreenState();
}

class _InviteHandlerScreenState extends ConsumerState<InviteHandlerScreen> {
  bool _isProcessing = false;

  Future<void> _acceptInvitation() async {
    // Client-side patient limit pre-check
    if (kPremiumEnabled) {
      final canAdd = await ref.read(canAddPatientProvider.future);
      if (!canAdd) {
        if (mounted) _showPatientLimitDialog();
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final cfService = ref.read(cloudFunctionsServiceProvider);
      await cfService.acceptInvite(widget.inviteCode);

      // Firestore streams auto-update; no manual invalidation needed.
      await ref.read(userSettingsProvider.notifier).updateIsCaregiver(true);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successfullyLinked),
          backgroundColor: AppColors.success,
        ),
      );

      context.go('/caregiver/patients');
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'acceptInvite');
      if (!mounted) return;

      setState(() => _isProcessing = false);

      final l10n = AppLocalizations.of(context)!;
      final message = _errorMessage(e, l10n);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.error),
      );
    }
  }

  String _errorMessage(Object e, AppLocalizations l10n) {
    if (e is FirebaseFunctionsException) {
      switch (e.code) {
        case 'not-found':
          return l10n.inviteNotFound;
        case 'failed-precondition':
          final details = e.message ?? '';
          if (details.toLowerCase().contains('expir'))
            return l10n.inviteExpired;
          return l10n.inviteAlreadyUsed;
        case 'invalid-argument':
          return l10n.inviteSelfError;
        case 'already-exists':
          return l10n.alreadyLinked;
        case 'resource-exhausted':
          return l10n.connectionLimitReached;
        default:
          return l10n.failedToAcceptInvite;
      }
    }
    return l10n.failedToAcceptInvite;
  }

  void _showPatientLimitDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: AppColors.warning,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(l10n.patientLimitReached)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.upgradeToPremium),
            const SizedBox(height: AppSpacing.md),
            PremiumInlineUpsell(message: l10n.unlimitedCaregivers),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton.icon(
            onPressed: kPremiumEnabled
                ? () {
                    Navigator.of(context).pop();
                    GoRouter.of(context).push(RouteNames.premium);
                  }
                : null,
            icon: const Icon(Icons.upgrade, size: AppSpacing.iconSm),
            label: Text(l10n.tryPremium),
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
          ),
        ],
      ),
    );
  }

  void _decline() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: KdAppBar(title: l10n.invitation, showBack: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: SingleChildScrollView(
              child: KdCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.group_add,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      l10n.youveBeenInvited,
                      style: textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : context.appColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.inviteCodeLabel(widget.inviteCode),
                      style: textTheme.bodyMedium?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (_isProcessing)
                      const CircularProgressIndicator.adaptive()
                    else ...[
                      KdButton(
                        label: l10n.acceptInvitation,
                        onPressed: _acceptInvitation,
                        icon: Icons.check,
                        variant: MpButtonVariant.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      KdButton(
                        label: l10n.decline,
                        onPressed: _decline,
                        icon: Icons.close,
                        variant: MpButtonVariant.text,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
