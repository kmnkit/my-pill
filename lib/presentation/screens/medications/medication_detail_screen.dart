import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusuridoki/core/utils/photo_encryption.dart';
import 'package:kusuridoki/data/providers/storage_service_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kusuridoki/core/constants/app_spacing.dart';
import 'package:kusuridoki/core/theme/app_colors_extension.dart';
import 'package:kusuridoki/data/providers/medication_provider.dart';
import 'package:kusuridoki/core/extensions/enum_l10n_extensions.dart';
import 'package:kusuridoki/data/providers/adherence_provider.dart';
import 'package:kusuridoki/data/providers/schedule_provider.dart';
import 'package:kusuridoki/data/enums/reminder_status.dart';
import 'package:kusuridoki/data/enums/schedule_type.dart';
import 'package:kusuridoki/l10n/app_localizations.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/adherence_badge.dart';
import 'package:kusuridoki/presentation/screens/medications/widgets/history_list_item.dart';
import 'package:kusuridoki/presentation/shared/dialogs/kd_confirm_dialog.dart';
import 'package:kusuridoki/presentation/shared/dialogs/inventory_update_dialog.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_app_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_badge.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_button.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_card.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_pill_icon.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_progress_bar.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_section_header.dart';
import 'package:kusuridoki/presentation/shared/widgets/kd_shimmer.dart';
import 'package:kusuridoki/presentation/shared/widgets/gradient_scaffold.dart';

class MedicationDetailScreen extends ConsumerWidget {
  final String medicationId;

  const MedicationDetailScreen({super.key, required this.medicationId});

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await KdConfirmDialog.show(
      context,
      title: l10n.deleteMedicationTitle,
      message: l10n.deleteMedicationConfirm,
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed == true && context.mounted) {
      await ref
          .read(medicationListProvider.notifier)
          .deleteMedication(medicationId);
      if (context.mounted) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final medicationAsync = ref.watch(medicationProvider(medicationId));
    final adherenceAsync = ref.watch(medicationAdherenceProvider(medicationId));
    final schedulesAsync = ref.watch(medicationSchedulesProvider(medicationId));
    final historyAsync = ref.watch(medicationHistoryProvider(medicationId));

    final medicationTitle = medicationAsync.when(
      data: (m) => m?.name ?? l10n.medications,
      loading: () => '',
      error: (_, _) => l10n.medications,
    );

    return GradientScaffold(
      appBar: KdAppBar(
        title: medicationTitle,
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push('/medications/$medicationId/edit');
            },
            iconSize: AppSpacing.iconMd,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _handleDelete(context, ref),
            iconSize: AppSpacing.iconMd,
          ),
        ],
      ),
      body: medicationAsync.when(
        data: (medication) {
          if (medication == null) {
            return Center(child: Text(l10n.medicationNotFound));
          }

          final isLowStock =
              medication.inventoryRemaining <= medication.lowStockThreshold;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Hero section
                Center(
                  child: Column(
                    children: [
                      if (medication.photoPath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          child: _EncryptedPhotoWidget(
                            photoPath: medication.photoPath!,
                          ),
                        )
                      else
                        Hero(
                          tag: 'medication-pill-$medicationId',
                          child: KdPillIcon(
                            shape: medication.shape,
                            color: medication.color,
                            size: 64,
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        medication.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        '${_formatDosage(medication.dosage)}${medication.dosageUnit.localizedName(l10n)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.appColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Inventory card
                KdCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.inventory,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (isLowStock)
                            KdBadge(
                              label: l10n.lowStock,
                              variant: MpBadgeVariant.lowStock,
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      KdProgressBar(
                        current: medication.inventoryRemaining,
                        total: medication.inventoryTotal,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      KdButton(
                        label: l10n.updateInventory,
                        variant: MpButtonVariant.secondary,
                        onPressed: () async {
                          final result = await InventoryUpdateDialog.show(
                            context,
                            currentRemaining: medication.inventoryRemaining,
                            currentTotal: medication.inventoryTotal,
                          );
                          if (result != null) {
                            final updated = medication.copyWith(
                              inventoryRemaining: result.remaining,
                              inventoryTotal: result.total,
                              updatedAt: DateTime.now(),
                            );
                            await ref
                                .read(medicationListProvider.notifier)
                                .updateMedication(updated);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Schedule info card
                KdCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.schedule,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      schedulesAsync.when(
                        data: (schedules) {
                          if (schedules.isEmpty) {
                            return _InfoRow(
                              label: l10n.status,
                              value: l10n.noScheduleConfigured,
                            );
                          }
                          final schedule = schedules.first;
                          return Column(
                            children: [
                              _InfoRow(
                                label: l10n.type,
                                value: schedule.type.localizedName(l10n),
                              ),
                              if (schedule.dosageSlots.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _InfoRow(
                                  label: l10n.dosageTimingTitle,
                                  value: schedule.dosageSlots
                                      .map(
                                        (slot) =>
                                            '${slot.timing.localizedName(l10n)} ${slot.time}',
                                      )
                                      .join(', '),
                                ),
                              ],
                              if (schedule.type == ScheduleType.specificDays &&
                                  schedule.specificDays.isNotEmpty) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _InfoRow(
                                  label: l10n.days,
                                  value: _formatDays(
                                    schedule.specificDays,
                                    l10n,
                                  ),
                                ),
                              ],
                              if (schedule.type == ScheduleType.interval &&
                                  schedule.intervalHours != null) ...[
                                const SizedBox(height: AppSpacing.sm),
                                _InfoRow(
                                  label: l10n.interval,
                                  value: l10n.everyNHoursLabel(
                                    schedule.intervalHours!,
                                  ),
                                ),
                              ],
                              const SizedBox(height: AppSpacing.sm),
                              _InfoRow(
                                label: l10n.added,
                                value: DateFormat(
                                  'MMM d, yyyy',
                                ).format(medication.createdAt),
                              ),
                            ],
                          );
                        },
                        loading: () => const KdShimmerBox(height: 48),
                        error: (_, _) => _InfoRow(
                          label: l10n.status,
                          value: l10n.errorLoadingSchedule,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Recent history
                KdSectionHeader(title: l10n.recentHistory),
                const SizedBox(height: AppSpacing.md),
                historyAsync.when(
                  data: (records) {
                    if (records.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            l10n.noHistoryYet,
                            style: TextStyle(
                              color: context.appColors.textMuted,
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: records.map((record) {
                        return HistoryListItem(
                          date: DateFormat('MMM d, yyyy').format(record.date),
                          time: DateFormat.jm(locale).format(record.scheduledTime),
                          wasTaken: record.status == ReminderStatus.taken,
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: KdListShimmer(itemCount: 3, itemHeight: 40),
                  ),
                  error: (_, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Text(
                        l10n.errorLoadingHistory,
                        style: TextStyle(color: context.appColors.textMuted),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Adherence badge
                adherenceAsync.when(
                  data: (adherence) => adherence != null
                      ? AdherenceBadge(percentage: (adherence * 100).round())
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
          );
        },
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: KdListShimmer(itemCount: 5),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.errorLoadingMedication),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () =>
                    ref.invalidate(medicationProvider(medicationId)),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: context.appColors.textMuted),
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

String _formatDosage(double dosage) {
  return dosage == dosage.truncateToDouble()
      ? dosage.toInt().toString()
      : dosage.toString();
}

String _formatDays(List<int> days, AppLocalizations l10n) {
  final dayNames = [
    l10n.mon,
    l10n.tue,
    l10n.wed,
    l10n.thu,
    l10n.fri,
    l10n.sat,
    l10n.sun,
  ];
  return days.map((d) => d >= 1 && d <= 7 ? dayNames[d - 1] : '?').join(', ');
}

class _EncryptedPhotoWidget extends ConsumerStatefulWidget {
  const _EncryptedPhotoWidget({required this.photoPath});

  final String photoPath;

  @override
  ConsumerState<_EncryptedPhotoWidget> createState() =>
      _EncryptedPhotoWidgetState();
}

class _EncryptedPhotoWidgetState extends ConsumerState<_EncryptedPhotoWidget> {
  Future<Uint8List>? _decryptFuture;

  @override
  void initState() {
    super.initState();
    _startDecryption();
  }

  @override
  void didUpdateWidget(_EncryptedPhotoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoPath != widget.photoPath) {
      _startDecryption();
    }
  }

  void _startDecryption() {
    if (PhotoEncryption.isEncrypted(widget.photoPath)) {
      final key = ref.read(storageServiceProvider).encryptionKeyBytes;
      _decryptFuture = PhotoEncryption.decryptFromFile(widget.photoPath, key);
    } else {
      _decryptFuture = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_decryptFuture != null) {
      return FutureBuilder<Uint8List>(
        future: _decryptFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            );
          }
          if (snapshot.hasError) {
            return SizedBox(
              width: 120,
              height: 120,
              child: Center(
                child: Icon(
                  Icons.broken_image,
                  color: context.appColors.textMuted,
                ),
              ),
            );
          }
          return const KdShimmerBox(
            width: 120,
            height: 120,
            borderRadius: AppSpacing.radiusMd,
          );
        },
      );
    }
    // Legacy unencrypted photo (pre-migration)
    return Image.file(
      File(widget.photoPath),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }
}
