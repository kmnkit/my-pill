import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/timezone_provider.dart';
import 'package:my_pill/presentation/screens/travel/widgets/affected_med_list.dart';
import 'package:my_pill/presentation/screens/travel/widgets/location_display.dart';
import 'package:my_pill/presentation/screens/travel/widgets/timezone_mode_selector.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_toggle_switch.dart';

class TravelModeScreen extends ConsumerWidget {
  const TravelModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timezoneState = ref.watch(timezoneSettingsProvider);

    return Scaffold(
      appBar: const MpAppBar(title: 'Travel Mode', showBack: true),
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
              label: 'Enable Travel Mode',
            ),
            if (timezoneState.enabled) ...[
              const SizedBox(height: AppSpacing.xl),
              const TimezoneModeSelector(),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Affected Medications',
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
                    Icon(Icons.info, size: AppSpacing.iconMd, color: AppColors.info),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'Consult your doctor for 3+ timezone changes',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMuted,
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
