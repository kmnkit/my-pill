import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kusuridoki/core/constants/app_colors.dart';
import 'package:kusuridoki/core/utils/error_handler.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/enums/dosage_unit.dart';
import 'package:kusuridoki/data/enums/pill_color.dart';
import 'package:kusuridoki/data/enums/pill_shape.dart';
import 'package:kusuridoki/data/models/medication.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/data/providers/settings_provider.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/inventory_editor.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/photo_picker_button.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/pill_color_picker.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/pill_shape_selector.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_text_field.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class AddMedicationScreen extends ConsumerStatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  ConsumerState<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState extends ConsumerState<AddMedicationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  DosageUnit _dosageUnit = DosageUnit.mg;
  PillShape _selectedShape = PillShape.round;
  PillColor _selectedColor = PillColor.white;
  int _inventoryCount = 30;
  bool _isCritical = false;
  bool _isIppoka = false;
  bool _isSaving = false;
  bool _defaultsApplied = false;
  String? _photoPath;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Apply smart default from user settings (once)
    if (!_defaultsApplied) {
      final settingsAsync = ref.read(userSettingsProvider);
      settingsAsync.whenData((settings) {
        if (settings.defaultIppoka) {
          _isIppoka = true;
          _selectedShape = PillShape.packet;
          _dosageUnit = DosageUnit.packs;
          _dosageController.text = '1';
        }
        _defaultsApplied = true;
      });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: GradientScaffold(
        appBar: KdAppBar(title: l10n.addMedication, showBack: true),
        body: SingleChildScrollView(
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
              KdTextField(
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
                    child: KdTextField(
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
                const SizedBox(height: AppSpacing.md),
                KdSectionHeader(title: l10n.pillShape),
                PillShapeSelector(
                  selectedShape: _selectedShape,
                  onShapeSelected: (shape) {
                    setState(() {
                      _selectedShape = shape;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                KdSectionHeader(title: l10n.pillColor),
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
              KdSectionHeader(title: l10n.inventory),
              InventoryEditor(
                count: _inventoryCount,
                onCountChanged: (newCount) {
                  setState(() {
                    _inventoryCount = newCount;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              KdSectionHeader(title: l10n.criticalMedication),
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
              KdButton(
                label: _isSaving ? l10n.saving : l10n.saveMedication,
                onPressed: _isSaving ? null : _saveMedication,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveMedication() async {
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
        isIppoka: _isIppoka,
        photoPath: _photoPath,
        createdAt: DateTime.now(),
      );

      await ref.read(medicationListProvider.notifier).addMedication(medication);

      if (mounted) {
        context.pushReplacement(
          '/medications/${medication.id}/schedule',
        );
      }
    } catch (e, st) {
      ErrorHandler.debugLog(e, st, 'addMedication');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.errorSavingMedication)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
