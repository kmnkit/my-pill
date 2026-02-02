import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/ad_service.dart';

part 'ad_provider.g.dart';

@riverpod
AdService adService(Ref ref) {
  final service = AdService();
  service.initialize();
  return service;
}
