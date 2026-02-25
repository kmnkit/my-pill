import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/enums/timezone_mode.dart';
import 'package:my_pill/data/models/dosage_time_slot.dart';
import 'package:my_pill/data/models/schedule.dart';
import 'package:my_pill/data/providers/schedule_provider.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/day_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/dosage_time_adjuster.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/dosage_timing_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/frequency_selector.dart';
import 'package:my_pill/presentation/screens/schedule/widgets/interval_picker.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.medicationId,
    this.initialScheduleType,
  });

  final String medicationId;
  final ScheduleType? initialScheduleType;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  late ScheduleType _selectedType;
  List<DosageTimeSlot> _dosageSlots = [];
  List<int> _selectedDays = [];
  int _intervalHours = 8;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialScheduleType ?? ScheduleType.daily;
  }

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
            // 1. Frequency selector (all types)
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

            // 2. Day selector (specificDays only)
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
            ],

            // 3. Interval picker (interval only)
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
            ],

            // 4. Dosage timing selector (shared across ALL types)
            Text(
              l10n.selectDosageTiming,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            DosageTimingSelector(
              selectedSlots: _dosageSlots,
              onChanged: (slots) {
                setState(() {
                  _dosageSlots = slots;
                });
              },
            ),

            // 5. Time adjuster (appears when slots exist)
            if (_dosageSlots.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xxl),
              Text(
                l10n.adjustTimes,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              DosageTimeAdjuster(
                slots: _dosageSlots,
                onSlotsChanged: (slots) {
                  setState(() {
                    _dosageSlots = slots;
                  });
                },
              ),
            ],

            // 6. Save button
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

    if (_dosageSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneTiming)),
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
      dosageSlots: _dosageSlots,
      specificDays: _selectedDays,
      intervalHours:
          _selectedType == ScheduleType.interval ? _intervalHours : null,
      timezoneMode: TimezoneMode.fixedInterval,
      isActive: true,
    );

    await ref.read(scheduleListProvider.notifier).addSchedule(schedule);

    if (mounted) {
      context.pop();
    }
  }
}
