import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:my_pill/core/constants/app_colors.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/data/enums/dosage_unit.dart';
import 'package:my_pill/data/enums/pill_color.dart';
import 'package:my_pill/data/enums/pill_shape.dart';
import 'package:my_pill/data/enums/schedule_type.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/interstitial_provider.dart';
import 'package:my_pill/presentation/screens/medications/widgets/inventory_editor.dart';
import 'package:my_pill/presentation/screens/medications/widgets/photo_picker_button.dart';
import 'package:my_pill/presentation/screens/medications/widgets/pill_color_picker.dart';
import 'package:my_pill/presentation/screens/medications/widgets/pill_shape_selector.dart';
import 'package:my_pill/presentation/screens/medications/widgets/schedule_type_selector.dart';
import 'package:my_pill/presentation/shared/widgets/mp_app_bar.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/presentation/shared/widgets/mp_section_header.dart';
import 'package:my_pill/presentation/shared/widgets/mp_text_field.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  DosageUnit _dosageUnit = DosageUnit.mg;
  PillShape _selectedShape = PillShape.round;
  PillColor _selectedColor = PillColor.white;
  ScheduleType _selectedScheduleType = ScheduleType.daily;
  int _inventoryCount = 30;
  bool _isCritical = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MpAppBar(
        title: 'Add Medication',
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MpTextField(
              controller: _nameController,
              label: 'Medication Name',
              hint: 'e.g., Aspirin',
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: MpTextField(
                    controller: _dosageController,
                    label: 'Dosage',
                    hint: '100',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unit',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      DropdownButtonFormField<DosageUnit>(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                        ),
                        items: DosageUnit.values
                            .map((unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit.label),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _dosageUnit = value;
                            });
                          }
                        },
                        initialValue: _dosageUnit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            const MpSectionHeader(title: 'Pill Shape'),
            PillShapeSelector(
              selectedShape: _selectedShape,
              onShapeSelected: (shape) {
                setState(() {
                  _selectedShape = shape;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            const MpSectionHeader(title: 'Pill Color'),
            PillColorPicker(
              selectedColor: _selectedColor,
              onColorSelected: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            const PhotoPickerButton(),
            const SizedBox(height: AppSpacing.xxl),
            const MpSectionHeader(title: 'Schedule Type'),
            ScheduleTypeSelector(
              selectedType: _selectedScheduleType,
              onTypeSelected: (type) {
                setState(() {
                  _selectedScheduleType = type;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            const MpSectionHeader(title: 'Inventory'),
            InventoryEditor(
              count: _inventoryCount,
              onCountChanged: (newCount) {
                setState(() {
                  _inventoryCount = newCount;
                });
              },
            ),
            const SizedBox(height: AppSpacing.xxl),
            const MpSectionHeader(title: 'Critical Alert'),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              title: Text(
                'Mark as Critical Medication',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              subtitle: Text(
                'Critical medications use high-priority alerts that can bypass Do Not Disturb',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
              ),
              value: _isCritical,
              onChanged: (value) {
                setState(() {
                  _isCritical = value;
                });
              },
              activeTrackColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.xxl),
            MpButton(
              label: _isSaving ? 'Saving...' : 'Save Medication',
              onPressed: _isSaving ? null : _saveMedication,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveMedication() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a medication name')),
      );
      return;
    }

    if (_dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a dosage')),
      );
      return;
    }

    final dosageValue = double.tryParse(_dosageController.text.trim());
    if (dosageValue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for dosage')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final medication = Medication(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        dosage: dosageValue,
        dosageUnit: _dosageUnit,
        shape: _selectedShape,
        color: _selectedColor,
        inventoryTotal: _inventoryCount,
        inventoryRemaining: _inventoryCount,
        isCritical: _isCritical,
        createdAt: DateTime.now(),
      );

      await ref.read(medicationListProvider.notifier).addMedication(medication);

      // Record action for interstitial frequency capping
      ref.read(interstitialControllerProvider).recordAction();
      await ref.read(maybeShowInterstitialProvider.future);

      if (mounted) {
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving medication: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
