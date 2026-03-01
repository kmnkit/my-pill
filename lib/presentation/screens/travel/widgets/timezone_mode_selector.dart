import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_radio_option.dart';

class TimezoneModeSelector extends ConsumerWidget {
  const TimezoneModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final timezoneState = ref.watch(timezoneSettingsProvider);

    return Column(
      children: [
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.fixedInterval,
          groupValue: timezoneState.mode,
          onChanged: (value) {
            ref.read(timezoneSettingsProvider.notifier).setMode(value);
          },
          icon: Icons.home,
          label: l10n.fixedInterval,
          description: l10n.fixedIntervalDesc,
        ),
        const SizedBox(height: AppSpacing.md),
        MpRadioOption<TimezoneMode>(
          value: TimezoneMode.localTime,
          groupValue: timezoneState.mode,
          onChanged: (value) {
            ref.read(timezoneSettingsProvider.notifier).setMode(value);
          },
          icon: Icons.wb_sunny,
          label: l10n.localTime,
          description: l10n.localTimeDesc,
        ),
      ],
    );
  }
}
