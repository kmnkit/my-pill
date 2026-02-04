import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/providers/timezone_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_card.dart';

/// Common timezones curated list - major cities and regions
const _commonTimezones = [
  // Asia
  'Asia/Seoul',
  'Asia/Tokyo',
  'Asia/Shanghai',
  'Asia/Hong_Kong',
  'Asia/Singapore',
  'Asia/Bangkok',
  'Asia/Ho_Chi_Minh',
  'Asia/Manila',
  'Asia/Jakarta',
  'Asia/Kolkata',
  'Asia/Dubai',
  // Europe
  'Europe/London',
  'Europe/Paris',
  'Europe/Berlin',
  'Europe/Rome',
  'Europe/Madrid',
  'Europe/Amsterdam',
  'Europe/Moscow',
  // Americas
  'America/New_York',
  'America/Chicago',
  'America/Denver',
  'America/Los_Angeles',
  'America/Toronto',
  'America/Vancouver',
  'America/Mexico_City',
  'America/Sao_Paulo',
  // Pacific
  'Pacific/Auckland',
  'Pacific/Sydney',
  'Australia/Melbourne',
  'Pacific/Honolulu',
  // UTC
  'UTC',
];

class OnboardingTimezoneStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ValueChanged<String> onTimezoneChanged;
  final String? initialTimezone;

  const OnboardingTimezoneStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onTimezoneChanged,
    this.initialTimezone,
  });

  @override
  ConsumerState<OnboardingTimezoneStep> createState() =>
      _OnboardingTimezoneStepState();
}

class _OnboardingTimezoneStepState
    extends ConsumerState<OnboardingTimezoneStep> {
  late String _selectedTimezone;

  @override
  void initState() {
    super.initState();
    _selectedTimezone = widget.initialTimezone ?? tz.local.name;
  }

  String _formatTimezone(String timezoneName) {
    try {
      final service = ref.read(timezoneServiceProvider);
      return service.formatTimezone(timezoneName);
    } catch (_) {
      return timezoneName;
    }
  }

  String _getDisplayName(String timezoneName) {
    // Convert "Asia/Seoul" to "Seoul"
    final parts = timezoneName.split('/');
    return parts.length > 1 ? parts.last.replaceAll('_', ' ') : timezoneName;
  }

  String _getRegion(String timezoneName) {
    // Convert "Asia/Seoul" to "Asia"
    final parts = timezoneName.split('/');
    return parts.isNotEmpty ? parts.first : '';
  }

  Future<void> _showTimezonePicker() async {
    // Start with common timezones, include current selection if not in list
    final baseList = List<String>.from(_commonTimezones);
    if (!baseList.contains(_selectedTimezone)) {
      baseList.insert(0, _selectedTimezone);
    }

    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TimezonePickerSheet(
        timezones: baseList,
        selectedTimezone: _selectedTimezone,
        formatTimezone: _formatTimezone,
        getDisplayName: _getDisplayName,
        getRegion: _getRegion,
      ),
    );

    if (selected != null && selected != _selectedTimezone) {
      setState(() {
        _selectedTimezone = selected;
      });
      widget.onTimezoneChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: widget.onBack,
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.onboardingBack),
            ),
          ),

          const Spacer(),

          // Center content
          Column(
            children: [
              // Icon
              Icon(
                Icons.access_time,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Title
              Text(
                l10n.onboardingTimezoneTitle,
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Subtitle
              Text(
                l10n.onboardingTimezoneSubtitle,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // Detected timezone display
              MpCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Text(
                        l10n.onboardingTimezoneDetected,
                        style: textTheme.labelLarge?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _selectedTimezone,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _formatTimezone(_selectedTimezone),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Change timezone button
              TextButton.icon(
                onPressed: _showTimezonePicker,
                icon: const Icon(Icons.edit),
                label: Text(l10n.onboardingTimezoneChange),
              ),
            ],
          ),

          const Spacer(),

          // Next button
          MpButton(
            label: l10n.onboardingNext,
            onPressed: widget.onNext,
            variant: MpButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet widget for timezone selection with search
class _TimezonePickerSheet extends StatefulWidget {
  final List<String> timezones;
  final String selectedTimezone;
  final String Function(String) formatTimezone;
  final String Function(String) getDisplayName;
  final String Function(String) getRegion;

  const _TimezonePickerSheet({
    required this.timezones,
    required this.selectedTimezone,
    required this.formatTimezone,
    required this.getDisplayName,
    required this.getRegion,
  });

  @override
  State<_TimezonePickerSheet> createState() => _TimezonePickerSheetState();
}

class _TimezonePickerSheetState extends State<_TimezonePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredTimezones {
    if (_searchQuery.isEmpty) return widget.timezones;
    final query = _searchQuery.toLowerCase();
    return widget.timezones.where((tz) {
      final displayName = widget.getDisplayName(tz).toLowerCase();
      final region = widget.getRegion(tz).toLowerCase();
      final tzLower = tz.toLowerCase();
      return tzLower.contains(query) ||
          displayName.contains(query) ||
          region.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: AppSpacing.sm),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.onboardingTimezonePickerTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.onboardingTimezoneSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Timezone list
          Expanded(
            child: _filteredTimezones.isEmpty
                ? Center(
                    child: Text(
                      l10n.onboardingTimezoneNoResults,
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: _filteredTimezones.length,
                    itemBuilder: (context, index) {
                      final tz = _filteredTimezones[index];
                      final isSelected = tz == widget.selectedTimezone;
                      final displayName = widget.getDisplayName(tz);
                      final region = widget.getRegion(tz);
                      final formattedTz = widget.formatTimezone(tz);

                      return ListTile(
                        title: Text(
                          displayName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          '$region • $formattedTz',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: AppColors.primary)
                            : null,
                        onTap: () => Navigator.pop(context, tz),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
