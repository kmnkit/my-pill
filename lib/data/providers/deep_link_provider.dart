import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_pill/data/services/deep_link_service.dart';

part 'deep_link_provider.g.dart';

@riverpod
DeepLinkService deepLinkService(Ref ref) {
  final service = DeepLinkService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
}

@riverpod
Stream<String> inviteCode(Ref ref) {
  final service = ref.watch(deepLinkServiceProvider);
  return service.inviteCodes;
}
