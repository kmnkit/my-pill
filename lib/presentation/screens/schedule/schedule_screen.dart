import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/day_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/dosage_multiplier.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/frequency_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/interval_picker.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/time_slot_picker.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  ScheduleType _selectedType = ScheduleType.daily;
  int _dosageCount = 1;

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
              TimeSlotPicker(dosageCount: _dosageCount),
            ],
            if (_selectedType == ScheduleType.specificDays) ...[
              Text(
                'Which days?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              const DaySelector(),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                'What time?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              const TimeSlotPicker(dosageCount: 1),
            ],
            if (_selectedType == ScheduleType.interval) ...[
              Text(
                'How often?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              const IntervalPicker(),
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

  void _saveSchedule() {
    // TODO: Wire to schedule provider when we have the complete Schedule model
    // For now, just pop back
    context.pop();
  }
}
