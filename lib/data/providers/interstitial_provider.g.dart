// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interstitial_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interstitialController)
final interstitialControllerProvider = InterstitialControllerProvider._();

final class InterstitialControllerProvider
    extends
        $FunctionalProvider<
          InterstitialController,
          InterstitialController,
          InterstitialController
        >
    with $Provider<InterstitialController> {
  InterstitialControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interstitialControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interstitialControllerHash();

  @$internal
  @override
  $ProviderElement<InterstitialController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InterstitialController create(Ref ref) {
    return interstitialController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InterstitialController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InterstitialController>(value),
    );
  }
}

String _$interstitialControllerHash() =>
    r'd2a0e779986655c52e9c5b7886d7c2e610591662';
