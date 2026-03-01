import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/timezone_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_card.dart';

class LocationDisplay extends ConsumerWidget {
  const LocationDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timezoneState = ref.watch(timezoneSettingsProvider);
    final timezoneService = ref.watch(timezoneServiceProvider);

    // Extract city names from timezone strings (e.g., "America/New_York" -> "New York")
    String getCityName(String timezone) {
      final parts = timezone.split('/');
      return parts.length > 1 ? parts.last.replaceAll('_', ' ') : timezone;
    }

    // Safely get timezone display with error handling
    String getTimezoneDisplay(String timezone) {
      try {
        return timezoneService.formatTimezone(timezone);
      } catch (e) {
        return timezone;
      }
    }

    // Safely get time difference with error handling
    String getTimeDifference() {
      try {
        final diff = timezoneService.getTimeDifference(
          timezoneState.homeTimezone,
          timezoneState.currentTimezone,
        );
        final sign = diff >= 0 ? '+' : '';
        return '$sign$diff hours';
      } catch (e) {
        return '0 hours';
      }
    }

    final l10n = AppLocalizations.of(context)!;
    final currentCity = getCityName(timezoneState.currentTimezone);
    final currentTz = getTimezoneDisplay(timezoneState.currentTimezone);
    final homeCity = getCityName(timezoneState.homeTimezone);
    final homeTz = getTimezoneDisplay(timezoneState.homeTimezone);
    final timeDiff = getTimeDifference();

    return MpCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: AppSpacing.iconMd,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${l10n.currentLocation}: $currentCity ($currentTz)',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.home,
                size: AppSpacing.iconMd,
                color: context.appColors.textMuted,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '${l10n.homeLocation}: $homeCity ($homeTz)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.timeDifference(timeDiff),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.appColors.textMuted),
          ),
        ],
      ),
    );
  }
}
