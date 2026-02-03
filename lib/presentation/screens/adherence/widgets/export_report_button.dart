import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_pill/l10n/app_localizations.dart';
import 'package:my_pill/data/providers/report_provider.dart';
import 'package:my_pill/data/providers/subscription_provider.dart';
import 'package:my_pill/data/providers/medication_provider.dart';
import 'package:my_pill/data/providers/storage_service_provider.dart';
import 'package:my_pill/presentation/shared/widgets/mp_button.dart';
import 'package:my_pill/core/constants/app_spacing.dart';
import 'package:my_pill/core/constants/app_colors.dart';

enum ReportPeriod { weekly, monthly }

class ExportReportButton extends ConsumerStatefulWidget {
  const ExportReportButton({super.key});

  @override
  ConsumerState<ExportReportButton> createState() => _ExportReportButtonState();
}

class _ExportReportButtonState extends ConsumerState<ExportReportButton> {
  bool _isGenerating = false;

  Future<void> _showReportDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final isPremium = ref.read(isPremiumProvider);

    if (!isPremium) {
      _showPremiumUpsell();
      return;
    }

    final period = await showDialog<ReportPeriod>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectReportPeriod),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.calendar_view_week),
              title: Text(l10n.weeklyReport),
              subtitle: Text(l10n.last7Days),
              onTap: () => Navigator.pop(context, ReportPeriod.weekly),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(l10n.monthlyReport),
              subtitle: Text(l10n.last30Days),
              onTap: () => Navigator.pop(context, ReportPeriod.monthly),
            ),
          ],
        ),
      ),
    );

    if (period != null && mounted) {
      await _generateReport(period);
    }
  }

  Future<void> _generateReport(ReportPeriod period) async {
    setState(() => _isGenerating = true);

    try {
      final l10n = AppLocalizations.of(context)!;
      final reportService = ref.read(reportServiceProvider);
      final storageService = ref.read(storageServiceProvider);
      final medications = await ref.read(medicationListProvider.future);
      const userName = 'User'; // TODO: Get from user profile when available

      final now = DateTime.now();
      late final File file;
      late final String reportType;

      if (period == ReportPeriod.weekly) {
        final startDate = now.subtract(const Duration(days: 6));
        final endDate = now;
        final records = await storageService.getAdherenceRecords(
          startDate: startDate,
          endDate: endDate,
        );

        file = await reportService.generateWeeklyReport(
          startDate: startDate,
          endDate: endDate,
          medications: medications,
          records: records,
          userName: userName,
        );
        reportType = l10n.weekly;
      } else {
        final startDate = DateTime(now.year, now.month, 1);
        final endDate = DateTime(now.year, now.month + 1, 0);
        final records = await storageService.getAdherenceRecords(
          startDate: startDate,
          endDate: endDate,
        );

        file = await reportService.generateMonthlyReport(
          month: now,
          medications: medications,
          records: records,
          userName: userName,
        );
        reportType = l10n.monthly;
      }

      if (mounted) {
        await reportService.shareReport(file, reportType);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.reportGeneratedSuccessfully),
              backgroundColor: AppColors.success,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorGeneratingReport),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showPremiumUpsell() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.workspace_premium, color: AppColors.warning),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.premiumFeature),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.pdfReportsRequirePremium),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.premiumBenefits,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildBenefitItem(l10n.weeklyMonthlyReports),
            _buildBenefitItem(l10n.detailedAdherenceStats),
            _buildBenefitItem(l10n.sharableWithDoctors),
            _buildBenefitItem(l10n.unlimitedCaregivers),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to subscription screen
              // context.push('/settings/subscription');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: Text(l10n.upgradeToPremium),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: AppColors.success, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return MpButton(
      label: l10n.exportReport,
      icon: _isGenerating ? null : Icons.file_download,
      onPressed: _isGenerating ? null : _showReportDialog,
      variant: MpButtonVariant.secondary,
      isFullWidth: false,
    );
  }
}
