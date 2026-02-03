import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:my_pill/data/models/adherence_record.dart';
import 'package:my_pill/data/models/medication.dart';
import 'package:my_pill/data/enums/reminder_status.dart';

class ReportService {
  /// Generate weekly medication adherence report
  Future<File> generateWeeklyReport({
    required DateTime startDate,
    required DateTime endDate,
    required List<Medication> medications,
    required List<AdherenceRecord> records,
    required String userName,
  }) async {
    final pdf = pw.Document();

    // Calculate statistics
    final taken = records.where((r) => r.status == ReminderStatus.taken).length;
    final missed = records.where((r) => r.status == ReminderStatus.missed).length;
    final skipped = records.where((r) => r.status == ReminderStatus.skipped).length;
    final total = taken + missed;
    final adherenceRate = total > 0 ? (taken / total * 100).toStringAsFixed(1) : '100.0';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader('Weekly Medication Report', startDate, endDate, userName),
          pw.SizedBox(height: 24),
          _buildSummarySection(taken, missed, skipped, adherenceRate),
          pw.SizedBox(height: 24),
          _buildMedicationBreakdown(medications, records),
          pw.SizedBox(height: 24),
          _buildDailyBreakdown(records, startDate, endDate),
        ],
      ),
    );

    // Save file
    final dir = await getTemporaryDirectory();
    final fileName = 'weekly_report_${DateFormat('yyyyMMdd').format(startDate)}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate monthly medication adherence report
  Future<File> generateMonthlyReport({
    required DateTime month,
    required List<Medication> medications,
    required List<AdherenceRecord> records,
    required String userName,
  }) async {
    final pdf = pw.Document();

    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);

    // Calculate statistics
    final taken = records.where((r) => r.status == ReminderStatus.taken).length;
    final missed = records.where((r) => r.status == ReminderStatus.missed).length;
    final skipped = records.where((r) => r.status == ReminderStatus.skipped).length;
    final total = taken + missed;
    final adherenceRate = total > 0 ? (taken / total * 100).toStringAsFixed(1) : '100.0';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildHeader(
            'Monthly Medication Report',
            startDate,
            endDate,
            userName,
          ),
          pw.SizedBox(height: 24),
          _buildSummarySection(taken, missed, skipped, adherenceRate),
          pw.SizedBox(height: 24),
          _buildMedicationBreakdown(medications, records),
          pw.SizedBox(height: 24),
          _buildWeeklyTrends(records, startDate, endDate),
        ],
      ),
    );

    // Save file
    final dir = await getTemporaryDirectory();
    final fileName = 'monthly_report_${DateFormat('yyyyMM').format(month)}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Share report via system share dialog
  Future<void> shareReport(File pdf, String reportType) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(pdf.path)],
        subject: 'MyPill $reportType Report',
        text: 'Medication adherence report from MyPill',
      ),
    );
  }

  // Private helper methods for PDF building

  pw.Widget _buildHeader(
    String title,
    DateTime startDate,
    DateTime endDate,
    String userName,
  ) {
    final dateFormat = DateFormat('MMM d, yyyy');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Patient: $userName',
          style: const pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _buildSummarySection(
    int taken,
    int missed,
    int skipped,
    String adherenceRate,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem('Adherence Rate', '$adherenceRate%', PdfColors.green),
              _buildStatItem('Taken', taken.toString(), PdfColors.blue),
              _buildStatItem('Missed', missed.toString(), PdfColors.red),
              _buildStatItem('Skipped', skipped.toString(), PdfColors.orange),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildStatItem(String label, String value, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
        ),
      ],
    );
  }

  pw.Widget _buildMedicationBreakdown(
    List<Medication> medications,
    List<AdherenceRecord> records,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Medication Breakdown',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: ['Medication', 'Taken', 'Missed', 'Adherence'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
          data: medications.map((med) {
            final medRecords = records.where((r) => r.medicationId == med.id);
            final taken = medRecords.where((r) => r.status == ReminderStatus.taken).length;
            final missed = medRecords.where((r) => r.status == ReminderStatus.missed).length;
            final total = taken + missed;
            final rate = total > 0 ? (taken / total * 100).toStringAsFixed(1) : '100.0';

            return [
              med.name,
              taken.toString(),
              missed.toString(),
              '$rate%',
            ];
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildDailyBreakdown(
    List<AdherenceRecord> records,
    DateTime startDate,
    DateTime endDate,
  ) {
    final days = endDate.difference(startDate).inDays + 1;
    final dailyData = <Map<String, dynamic>>[];

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dayRecords = records.where((r) =>
        r.date.year == date.year &&
        r.date.month == date.month &&
        r.date.day == date.day
      );

      final taken = dayRecords.where((r) => r.status == ReminderStatus.taken).length;
      final missed = dayRecords.where((r) => r.status == ReminderStatus.missed).length;
      final total = taken + missed;
      final rate = total > 0 ? (taken / total * 100).toStringAsFixed(1) : '100.0';

      dailyData.add({
        'date': DateFormat('EEE, MMM d').format(date),
        'taken': taken,
        'missed': missed,
        'rate': rate,
      });
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Daily Breakdown',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: ['Date', 'Taken', 'Missed', 'Adherence'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
          data: dailyData.map((day) => [
            day['date'],
            day['taken'].toString(),
            day['missed'].toString(),
            '${day['rate']}%',
          ]).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildWeeklyTrends(
    List<AdherenceRecord> records,
    DateTime startDate,
    DateTime endDate,
  ) {
    final weeks = ((endDate.difference(startDate).inDays + 1) / 7).ceil();
    final weeklyData = <Map<String, dynamic>>[];

    for (int i = 0; i < weeks; i++) {
      final weekStart = startDate.add(Duration(days: i * 7));
      final weekEnd = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day + 6,
      );

      final weekRecords = records.where((r) =>
        r.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        r.date.isBefore(weekEnd.add(const Duration(days: 1)))
      );

      final taken = weekRecords.where((r) => r.status == ReminderStatus.taken).length;
      final missed = weekRecords.where((r) => r.status == ReminderStatus.missed).length;
      final total = taken + missed;
      final rate = total > 0 ? (taken / total * 100).toStringAsFixed(1) : '100.0';

      weeklyData.add({
        'week': 'Week ${i + 1}',
        'taken': taken,
        'missed': missed,
        'rate': rate,
      });
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Weekly Trends',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 12),
        pw.TableHelper.fromTextArray(
          headers: ['Week', 'Taken', 'Missed', 'Adherence'],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
          data: weeklyData.map((week) => [
            week['week'],
            week['taken'].toString(),
            week['missed'].toString(),
            '${week['rate']}%',
          ]).toList(),
        ),
      ],
    );
  }
}
