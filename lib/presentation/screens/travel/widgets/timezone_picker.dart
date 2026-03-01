import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';

/// Shows a bottom sheet timezone picker and returns the selected timezone name,
/// or null if dismissed.
Future<String?> showTimezonePicker(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusXl),
      ),
    ),
    builder: (context) => const _TimezonePickerSheet(),
  );
}

class _TimezonePickerSheet extends StatefulWidget {
  const _TimezonePickerSheet();

  @override
  State<_TimezonePickerSheet> createState() => _TimezonePickerSheetState();
}

class _TimezonePickerSheetState extends State<_TimezonePickerSheet> {
  final _searchController = TextEditingController();
  late final List<_TimezoneEntry> _allTimezones;
  List<_TimezoneEntry> _filtered = [];

  @override
  void initState() {
    super.initState();
    _allTimezones = _buildTimezoneList();
    _filtered = _allTimezones;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_TimezoneEntry> _buildTimezoneList() {
    final now = tz.TZDateTime.now(tz.UTC);
    final entries = <_TimezoneEntry>[];

    for (final name in tz.timeZoneDatabase.locations.keys) {
      // Skip overly technical names (Etc/*, SystemV/*, posix/*, right/*)
      if (name.startsWith('Etc/') ||
          name.startsWith('SystemV/') ||
          name.startsWith('posix/') ||
          name.startsWith('right/')) {
        continue;
      }

      final location = tz.getLocation(name);
      final tzTime = tz.TZDateTime.now(location);
      final offset = location.timeZone(now.millisecondsSinceEpoch).offset;
      final offsetHours = offset.inMilliseconds / 3600000;
      final cityName = name.split('/').last.replaceAll('_', ' ');
      final abbr = tzTime.timeZoneName;
      final sign = offsetHours >= 0 ? '+' : '';
      final offsetStr = offsetHours == offsetHours.roundToDouble()
          ? '$sign${offsetHours.round()}'
          : '$sign${offsetHours.toStringAsFixed(1)}';

      entries.add(_TimezoneEntry(
        name: name,
        cityName: cityName,
        displayLabel: '$cityName ($abbr UTC$offsetStr)',
        offsetMillis: offset.inMilliseconds,
      ));
    }

    // Sort by UTC offset, then city name
    entries.sort((a, b) {
      final cmp = a.offsetMillis.compareTo(b.offsetMillis);
      if (cmp != 0) return cmp;
      return a.cityName.compareTo(b.cityName);
    });

    return entries;
  }

  void _onSearchChanged(String query) {
    final lower = query.toLowerCase();
    setState(() {
      if (lower.isEmpty) {
        _filtered = _allTimezones;
      } else {
        _filtered = _allTimezones
            .where((e) =>
                e.cityName.toLowerCase().contains(lower) ||
                e.name.toLowerCase().contains(lower))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.appColors.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                l10n.selectDestinationTimezone,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: l10n.searchTimezone,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            // Timezone list
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text(
                        l10n.onboardingTimezoneNoResults,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.appColors.textMuted,
                            ),
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      itemCount: _filtered.length,
                      itemBuilder: (context, index) {
                        final entry = _filtered[index];
                        return ListTile(
                          title: Text(entry.displayLabel),
                          dense: true,
                          onTap: () => Navigator.of(context).pop(entry.name),
                          leading: Icon(
                            Icons.schedule,
                            size: AppSpacing.iconSm,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _TimezoneEntry {
  const _TimezoneEntry({
    required this.name,
    required this.cityName,
    required this.displayLabel,
    required this.offsetMillis,
  });

  final String name;
  final String cityName;
  final String displayLabel;
  final int offsetMillis;
}
