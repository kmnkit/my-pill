import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/enums/timezone_mode.dart';
import 'package:kusuridoki/data/models/dosage_time_slot.dart';
import 'package:kusuridoki/data/models/schedule.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/providers/reminder_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/day_selector.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/dosage_time_adjuster.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/dosage_timing_selector.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/frequency_selector.dart';
import 'package:kusuridoki/presentation/screens/schedule/widgets/interval_picker.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.medicationId,
    this.isInitialSetup = false,
  });

  final String medicationId;
  final bool isInitialSetup;

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  late ScheduleType _selectedType;
  List<DosageTimeSlot> _dosageSlots = [];
  List<int> _selectedDays = [];
  int _intervalHours = 8;
  bool _isSaving = false;
  bool _isLoadingSchedule = true;
  String? _existingScheduleId;

  @override
  void initState() {
    super.initState();
    _selectedType = ScheduleType.daily;
    _loadExistingSchedule();
  }

  Future<void> _loadExistingSchedule() async {
    final schedules = await ref.read(
      medicationSchedulesProvider(widget.medicationId).future,
    );
    if (!mounted) return;
    if (schedules.isNotEmpty) {
      final schedule = schedules.first;
      setState(() {
        _existingScheduleId = schedule.id;
        _selectedType = schedule.type;
        _dosageSlots = schedule.dosageSlots;
        _selectedDays = schedule.specificDays;
        _intervalHours = schedule.intervalHours ?? 8;
      });
    }
    setState(() => _isLoadingSchedule = false);
  }

  Future<void> _handleBackPress() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cancelScheduleSetupTitle),
        content: Text(l10n.cancelScheduleSetupMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref
          .read(medicationListProvider.notifier)
          .deleteMedication(widget.medicationId);
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final scaffold = Scaffold(
      appBar: KdAppBar(title: l10n.setSchedule, showBack: true),
      body: _isLoadingSchedule
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SingleChildScrollView(
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
                      initialDays: _selectedDays,
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
                      initialHours: _intervalHours,
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
                  KdButton(
                    label: _isSaving ? l10n.saving : l10n.continueButton,
                    onPressed: _isSaving ? null : _saveSchedule,
                  ),
                ],
              ),
            ),
    );

    if (!widget.isInitialSetup) return scaffold;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackPress();
      },
      child: scaffold,
    );
  }

  Future<void> _saveSchedule() async {
    final l10n = AppLocalizations.of(context)!;

    if (_dosageSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseSelectAtLeastOneTiming)),
      );
      return;
    }

    if (_selectedType == ScheduleType.specificDays && _selectedDays.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectAtLeastOneDay)));
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (_existingScheduleId != null) {
        final updatedSchedule = Schedule(
          id: _existingScheduleId!,
          medicationId: widget.medicationId,
          type: _selectedType,
          dosageSlots: _dosageSlots,
          specificDays: _selectedDays,
          intervalHours: _selectedType == ScheduleType.interval
              ? _intervalHours
              : null,
          timezoneMode: TimezoneMode.fixedInterval,
          isActive: true,
        );
        await ref
            .read(scheduleListProvider.notifier)
            .updateSchedule(updatedSchedule);
      } else {
        final schedule = Schedule(
          id: const Uuid().v4(),
          medicationId: widget.medicationId,
          type: _selectedType,
          dosageSlots: _dosageSlots,
          specificDays: _selectedDays,
          intervalHours: _selectedType == ScheduleType.interval
              ? _intervalHours
              : null,
          timezoneMode: TimezoneMode.fixedInterval,
          isActive: true,
        );
        await ref.read(scheduleListProvider.notifier).addSchedule(schedule);
      }

      // Generate reminders so Home reflects the change immediately.
      // Failures here are non-fatal — reminders regenerate on Home screen entry.
      try {
        await ref
            .read(todayRemindersProvider.notifier)
            .generateAndScheduleToday();
      } catch (e, st) {
        debugPrint('Reminder generation failed (non-fatal): $e\n$st');
      }

      if (mounted) {
        context.pop();
      }
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'saveSchedule');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorSavingSchedule)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
