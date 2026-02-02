import 'package:flutter/material.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/presentation/shared/widgets/mp_time_picker.dart';

class TimeSlotPicker extends StatefulWidget {
  const TimeSlotPicker({
    super.key,
    required this.dosageCount,
  });

  final int dosageCount;

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  final List<TimeSlot> _timeSlots = [TimeSlot(hour: 8, minute: 0)];

  void _addTimeSlot() {
    setState(() {
      _timeSlots.add(TimeSlot(hour: 12, minute: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleSlots = _timeSlots.take(widget.dosageCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < visibleSlots.length; i++) ...[
          MpTimePicker(
            hour: visibleSlots[i].hour,
            minute: visibleSlots[i].minute,
            onHourChanged: (value) {
              setState(() {
                _timeSlots[i] = TimeSlot(hour: value, minute: visibleSlots[i].minute);
              });
            },
            onMinuteChanged: (value) {
              setState(() {
                _timeSlots[i] = TimeSlot(hour: visibleSlots[i].hour, minute: value);
              });
            },
          ),
          if (i < visibleSlots.length - 1) const SizedBox(height: AppSpacing.md),
        ],
        if (_timeSlots.length < 4) ...[
          const SizedBox(height: AppSpacing.md),
          TextButton.icon(
            onPressed: _addTimeSlot,
            icon: const Icon(Icons.add),
            label: const Text('Add another time'),
          ),
        ],
      ],
    );
  }
}

class TimeSlot {
  final int hour;
  final int minute;

  TimeSlot({required this.hour, required this.minute});
}
