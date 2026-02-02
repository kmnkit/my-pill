import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
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
    return Scaffold(
      appBar: const MpAppBar(
        title: 'Set Schedule',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How often?',
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
                'How many times per day?',
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
                'What times?',
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
                'Which days?',
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
                'What time?',
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
                'How often?',
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
            ],
            const SizedBox(height: AppSpacing.xxxl),
            MpButton(
              label: 'Continue',
              onPressed: _saveSchedule,
            ),
          ],
        ),
      ),
    );
  }

  void _saveSchedule() async {
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
