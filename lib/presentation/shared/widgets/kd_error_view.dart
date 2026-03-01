import 'package:flutter/material.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';

class MpErrorView extends StatelessWidget {
  const MpErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  String _getLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (ErrorHandler.getErrorCode(error)) {
      ErrorCode.network => l10n.networkError,
      ErrorCode.timeout => l10n.timeoutError,
      ErrorCode.serviceUnavailable => l10n.serviceUnavailable,
      ErrorCode.permissionDenied => l10n.permissionDenied,
      ErrorCode.generic => l10n.genericError,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.lg),
            Text(
              _getLocalizedMessage(context),
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              MpButton(
                label: AppLocalizations.of(context)!.retry,
                onPressed: onRetry,
                variant: MpButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
