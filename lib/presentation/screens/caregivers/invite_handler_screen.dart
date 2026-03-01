import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/providers/caregiver_provider.dart';
import 'package:kusuridoki/data/providers/invite_provider.dart';
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
    setState(() => _isProcessing = true);

    try {
      final cfService = ref.read(cloudFunctionsServiceProvider);
      await cfService.acceptInvite(widget.inviteCode);

      // Refresh caregiver links after successful accept
      ref.invalidate(caregiverLinksProvider);

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.successfullyLinked),
          backgroundColor: AppColors.success,
        ),
      );

      context.go('/home');
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'acceptInvite');
      if (!mounted) return;

      setState(() => _isProcessing = false);

      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToAcceptInvite),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        fontWeight: FontWeight.w600,
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
                      const CircularProgressIndicator()
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
