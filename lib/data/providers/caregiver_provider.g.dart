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

/// Check if user can add another caregiver based on subscription tier

@ProviderFor(canAddCaregiver)
final canAddCaregiverProvider = CanAddCaregiverProvider._();

/// Check if user can add another caregiver based on subscription tier

final class CanAddCaregiverProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Check if user can add another caregiver based on subscription tier
  CanAddCaregiverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'canAddCaregiverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$canAddCaregiverHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return canAddCaregiver(ref);
  }
}

String _$canAddCaregiverHash() => r'7905758a025421559f3fcc28efaab7ce02d2e78a';

/// Get the number of remaining caregiver slots

@ProviderFor(remainingCaregiverSlots)
final remainingCaregiverSlotsProvider = RemainingCaregiverSlotsProvider._();

/// Get the number of remaining caregiver slots

final class RemainingCaregiverSlotsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// Get the number of remaining caregiver slots
  RemainingCaregiverSlotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remainingCaregiverSlotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remainingCaregiverSlotsHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return remainingCaregiverSlots(ref);
  }
}

String _$remainingCaregiverSlotsHash() =>
    r'0a60211af92497ac186db7a67ab70d994968938e';
