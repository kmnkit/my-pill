// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caregiver_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CaregiverLinks)
final caregiverLinksProvider = CaregiverLinksProvider._();

final class CaregiverLinksProvider
    extends $AsyncNotifierProvider<CaregiverLinks, List<CaregiverLink>> {
  CaregiverLinksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'caregiverLinksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$caregiverLinksHash();

  @$internal
  @override
  CaregiverLinks create() => CaregiverLinks();
}

String _$caregiverLinksHash() => r'253f45444e9753b6bdf90cb90bb2f46fa376f0c9';

abstract class _$CaregiverLinks extends $AsyncNotifier<List<CaregiverLink>> {
  FutureOr<List<CaregiverLink>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<CaregiverLink>>, List<CaregiverLink>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<CaregiverLink>>, List<CaregiverLink>>,
              AsyncValue<List<CaregiverLink>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
