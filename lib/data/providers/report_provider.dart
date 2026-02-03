import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/report_service.dart';

part 'report_provider.g.dart';

@riverpod
ReportService reportService(Ref ref) {
  return ReportService();
}
