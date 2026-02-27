import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/inventory_editor.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/photo_picker_button.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/pill_color_picker.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/pill_shape_selector.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/schedule_type_selector.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/mp_text_field.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class EditMedicationScreen extends ConsumerStatefulWidget {
  final String medicationId;

  const EditMedicationScreen({super.key, required this.medicationId});

  @override
  ConsumerState<EditMedicationScreen> createState() =>
      _EditMedicationScreenState();
}

class _EditMedicationScreenState extends ConsumerState<EditMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  DosageUnit _dosageUnit = DosageUnit.mg;
  PillShape _selectedShape = PillShape.round;
  PillColor _selectedColor = PillColor.white;
  ScheduleType _selectedScheduleType = ScheduleType.daily;
  int _inventoryCount = 30;
  bool _isCritical = false;
  bool _isIppoka = false;
  bool _isSaving = false;
  bool _isInitialized = false;
  String? _photoPath;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  void _initializeFormFields(Medication medication) {
    if (_isInitialized) return;

    _nameController.text = medication.name;
    _dosageController.text = medication.dosage.toString();
    _dosageUnit = medication.dosageUnit;
    _selectedShape = medication.shape;
    _selectedColor = medication.color;
    _inventoryCount = medication.inventoryRemaining;
    _isCritical = medication.isCritical;
    _isIppoka = medication.isIppoka;
    _photoPath = medication.photoPath;

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final medicationAsync = ref.watch(medicationProvider(widget.medicationId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GradientScaffold(
        appBar: MpAppBar(title: l10n.editMedication, showBack: true),
        body: medicationAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.errorLoadingMedication,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          data: (medication) {
            if (medication == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.medication_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.medicationNotFound,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              );
            }

            _initializeFormFields(medication);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SwitchListTile(
                    title: Text(
                      l10n.ippokaModeLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      l10n.ippokaDesc,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textMuted,
                      ),
                    ),
                    value: _isIppoka,
                    onChanged: (value) {
                      setState(() {
                        _isIppoka = value;
                        if (value) {
                          _selectedShape = PillShape.packet;
                          _dosageUnit = DosageUnit.packs;
                          _dosageController.text = '1';
                        } else {
                          _selectedShape = PillShape.round;
                          _dosageUnit = DosageUnit.mg;
                          _dosageController.text = '';
                        }
                      });
                    },
                    activeTrackColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  MpTextField(
                    controller: _nameController,
                    label: l10n.medicationName,
                    hint: _isIppoka ? l10n.ippokaNameHint : l10n.dosageHint,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: MpTextField(
                          controller: _dosageController,
                          label: l10n.dosage,
                          hint: '100',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dosageUnit,
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
                                  .map(
                                    (unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit.localizedName(l10n)),
                                    ),
                                  )
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
                  if (!_isIppoka) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    MpSectionHeader(title: l10n.pillShape),
                    PillShapeSelector(
                      selectedShape: _selectedShape,
                      onShapeSelected: (shape) {
                        setState(() {
                          _selectedShape = shape;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    MpSectionHeader(title: l10n.pillColor),
                    PillColorPicker(
                      selectedColor: _selectedColor,
                      onColorSelected: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  PhotoPickerButton(
                    currentPhotoPath: _photoPath,
                    onPhotoChanged: (path) {
                      setState(() => _photoPath = path);
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MpSectionHeader(title: l10n.scheduleType),
                  ScheduleTypeSelector(
                    selectedType: _selectedScheduleType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedScheduleType = type;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MpSectionHeader(title: l10n.inventory),
                  InventoryEditor(
                    count: _inventoryCount,
                    onCountChanged: (newCount) {
                      setState(() {
                        _inventoryCount = newCount;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MpSectionHeader(title: l10n.criticalMedication),
                  const SizedBox(height: AppSpacing.sm),
                  SwitchListTile(
                    title: Text(
                      l10n.criticalMedicationLabel,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      l10n.criticalMedicationDesc,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: context.appColors.textMuted,
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
                    label: _isSaving ? l10n.updating : l10n.updateMedication,
                    onPressed: _isSaving
                        ? null
                        : () => _updateMedication(medication),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _updateMedication(Medication originalMedication) async {
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterMedicationName)));
      return;
    }

    if (_dosageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterDosage)));
      return;
    }

    final dosageValue = double.tryParse(_dosageController.text.trim());
    if (dosageValue == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterValidDosage)));
      return;
    }

    if (dosageValue <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.dosageMustBePositive)));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedMedication = originalMedication.copyWith(
        name: _nameController.text.trim(),
        dosage: dosageValue,
        dosageUnit: _dosageUnit,
        shape: _selectedShape,
        color: _selectedColor,
        inventoryRemaining: _inventoryCount,
        isCritical: _isCritical,
        isIppoka: _isIppoka,
        photoPath: _photoPath,
        updatedAt: DateTime.now(),
      );

      await ref
          .read(medicationListProvider.notifier)
          .updateMedication(updatedMedication);

      if (mounted) {
        context.pop();
      }
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'editMedication');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorUpdatingMedication)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
