// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(subscriptionService)
final subscriptionServiceProvider = SubscriptionServiceProvider._();

final class SubscriptionServiceProvider
    extends
        $FunctionalProvider<
          SubscriptionService,
          SubscriptionService,
          SubscriptionService
        >
    with $Provider<SubscriptionService> {
  SubscriptionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionServiceHash();

  @$internal
  @override
  $ProviderElement<SubscriptionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionService create(Ref ref) {
    return subscriptionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionService>(value),
    );
  }
}

String _$subscriptionServiceHash() =>
    r'b690ec9be8feb718c2901624b91e29107f74bc39';

@ProviderFor(isPremium)
final isPremiumProvider = IsPremiumProvider._();

final class IsPremiumProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsPremiumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isPremiumProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isPremiumHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isPremium(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isPremiumHash() => r'280037c1194a1e342e877654dbff90ca37052f01';

@ProviderFor(maxCaregivers)
final maxCaregiversProvider = MaxCaregiversProvider._();

final class MaxCaregiversProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  MaxCaregiversProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxCaregiversProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxCaregiversHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return maxCaregivers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$maxCaregiversHash() => r'582eb67fbb8c36638f4e1a8858c8cfabf71c0689';

@ProviderFor(maxPatients)
final maxPatientsProvider = MaxPatientsProvider._();

final class MaxPatientsProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  MaxPatientsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxPatientsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxPatientsHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return maxPatients(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$maxPatientsHash() => r'134ac974a4cae4d71c9924b4bc6afc8978b69d32';

@ProviderFor(subscriptionStatus)
final subscriptionStatusProvider = SubscriptionStatusProvider._();

final class SubscriptionStatusProvider
    extends
        $FunctionalProvider<
          SubscriptionStatus,
          SubscriptionStatus,
          SubscriptionStatus
        >
    with $Provider<SubscriptionStatus> {
  SubscriptionStatusProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subscriptionStatusProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subscriptionStatusHash();

  @$internal
  @override
  $ProviderElement<SubscriptionStatus> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubscriptionStatus create(Ref ref) {
    return subscriptionStatus(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubscriptionStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubscriptionStatus>(value),
    );
  }
}

String _$subscriptionStatusHash() =>
    r'866f9bdcb61a3603b7b4a16de36eb74bbdf2d820';
