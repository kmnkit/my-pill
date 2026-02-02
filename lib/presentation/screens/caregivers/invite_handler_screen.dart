import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

class InviteHandlerScreen extends ConsumerStatefulWidget {
  const InviteHandlerScreen({
    super.key,
    required this.inviteCode,
  });

  final String inviteCode;

  @override
  ConsumerState<InviteHandlerScreen> createState() =>
      _InviteHandlerScreenState();
}

class _InviteHandlerScreenState extends ConsumerState<InviteHandlerScreen> {
  bool _isProcessing = false;

  Future<void> _acceptInvitation() async {
    setState(() => _isProcessing = true);

    // Simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invitation accepted! (Firebase integration pending)'),
        backgroundColor: AppColors.success,
      ),
    );

    setState(() => _isProcessing = false);
    context.go('/home');
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
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const MpAppBar(
        title: 'Invitation',
        showBack: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: SingleChildScrollView(
              child: MpCard(
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
                      "You've been invited!",
                      style: textTheme.headlineSmall?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Invite Code: ${widget.inviteCode}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    if (_isProcessing)
                      const CircularProgressIndicator()
                    else ...[
                      MpButton(
                        label: 'Accept Invitation',
                        onPressed: _acceptInvitation,
                        icon: Icons.check,
                        variant: MpButtonVariant.primary,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      MpButton(
                        label: 'Decline',
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
