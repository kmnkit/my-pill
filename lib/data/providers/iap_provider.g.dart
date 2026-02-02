// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iap_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(iapService)
final iapServiceProvider = IapServiceProvider._();

final class IapServiceProvider
    extends $FunctionalProvider<IapService, IapService, IapService>
    with $Provider<IapService> {
  IapServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'iapServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$iapServiceHash();

  @$internal
  @override
  $ProviderElement<IapService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IapService create(Ref ref) {
    return iapService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IapService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IapService>(value),
    );
  }
}

String _$iapServiceHash() => r'2f2fdff2e37d2f98c9b5b4c364582de106c634f0';

@ProviderFor(adsRemoved)
final adsRemovedProvider = AdsRemovedProvider._();

final class AdsRemovedProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  AdsRemovedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adsRemovedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adsRemovedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return adsRemoved(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$adsRemovedHash() => r'56ae050f373c6ba8c97d5dc8b367c33b94ff5112';
