import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/storage_service.dart';

part 'storage_service_provider.g.dart';

@riverpod
StorageService storageService(Ref ref) {
  return StorageService();
}
