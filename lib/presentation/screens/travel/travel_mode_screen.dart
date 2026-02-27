import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/affected_med_list.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/location_display.dart';
import 'package:kusuridoki/presentation/screens/travel/widgets/timezone_mode_selector.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_toggle_switch.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class TravelModeScreen extends ConsumerWidget {
  const TravelModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final timezoneState = ref.watch(timezoneSettingsProvider);

    return GradientScaffold(
      appBar: MpAppBar(title: l10n.travelMode, showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationDisplay(),
            const SizedBox(height: AppSpacing.xl),
            MpToggleSwitch(
              value: timezoneState.enabled,
              onChanged: (_) {
                ref.read(timezoneSettingsProvider.notifier).toggleEnabled();
              },
              label: l10n.enableTravelMode,
            ),
            if (timezoneState.enabled) ...[
              const SizedBox(height: AppSpacing.xl),
              const TimezoneModeSelector(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.affectedMedications,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              const AffectedMedList(),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      size: AppSpacing.iconMd,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        l10n.consultDoctor,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
