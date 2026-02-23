import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/day_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/dosage_multiplier.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/frequency_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/interval_picker.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/time_slot_picker.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.medicationId,
  });

  final String medicationId;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScheduleType _selectedType = ScheduleType.daily;
  int _dosageCount = 1;
  List<String> _times = [];
  List<int> _selectedDays = [];
  int _intervalHours = 8;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: MpAppBar(
        title: l10n.setSchedule,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.howOften,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            FrequencySelector(
              selectedType: _selectedType,
              onChanged: (type) {
                setState(() {
                  _selectedType = type;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_selectedType == ScheduleType.daily) ...[
              Text(
                l10n.howManyTimesPerDay,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              DosageMultiplier(
                selectedCount: _dosageCount,
                onChanged: (count) {
                  setState(() {
                    _dosageCount = count;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.whatTimes,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TimeSlotPicker(
                dosageCount: _dosageCount,
                onTimesChanged: (times) {
                  setState(() {
                    _times = times;
                  });
                },
              ),
            ],
            if (_selectedType == ScheduleType.specificDays) ...[
              Text(
                l10n.whichDays,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              DaySelector(
                onDaysChanged: (days) {
                  setState(() {
                    _selectedDays = days;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.whatTime,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TimeSlotPicker(
                dosageCount: 1,
                onTimesChanged: (times) {
                  setState(() {
                    _times = times;
                  });
                },
              ),
            ],
            if (_selectedType == ScheduleType.interval) ...[
              Text(
                l10n.howOften,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              IntervalPicker(
                onIntervalChanged: (hours) {
                  setState(() {
                    _intervalHours = hours;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.whatTime,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TimeSlotPicker(
                dosageCount: 1,
                onTimesChanged: (times) {
                  setState(() {
                    _times = times;
                  });
                },
              ),
            ],
            const SizedBox(height: AppSpacing.xxxl),
            MpButton(
              label: l10n.continueButton,
              onPressed: _saveSchedule,
            ),
          ],
        ),
      ),
    );
  }

  void _saveSchedule() async {
    final l10n = AppLocalizations.of(context)!;

    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneTime)),
      );
      return;
    }

    if (_selectedType == ScheduleType.specificDays && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneDay)),
      );
      return;
    }

    final schedule = Schedule(
      id: const Uuid().v4(),
      medicationId: widget.medicationId,
      type: _selectedType,
      timesPerDay: _dosageCount,
      times: _times,
      specificDays: _selectedDays,
      intervalHours: _selectedType == ScheduleType.interval ? _intervalHours : null,
      timezoneMode: TimezoneMode.fixedInterval,
      isActive: true,
    );

    await ref.read(scheduleListProvider.notifier).addSchedule(schedule);

    if (mounted) {
      context.pop();
    }
  }
}
