// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(routerRefreshNotifier)
final routerRefreshProvider = RouterRefreshNotifierProvider._();

final class RouterRefreshNotifierProvider
    extends
        $FunctionalProvider<
          RouterRefreshNotifier,
          RouterRefreshNotifier,
          RouterRefreshNotifier
        >
    with $Provider<RouterRefreshNotifier> {
  RouterRefreshNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerRefreshNotifierHash();

  @$internal
  @override
  $ProviderElement<RouterRefreshNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RouterRefreshNotifier create(Ref ref) {
    return routerRefreshNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouterRefreshNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouterRefreshNotifier>(value),
    );
  }
}

String _$routerRefreshNotifierHash() =>
    r'3fb6ba9232b76292ea96cc1b7fff2b09f9483520';

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

final class AppRouterProvider
    extends $FunctionalProvider<Raw<GoRouter>, Raw<GoRouter>, Raw<GoRouter>>
    with $Provider<Raw<GoRouter>> {
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<Raw<GoRouter>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Raw<GoRouter> create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Raw<GoRouter> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Raw<GoRouter>>(value),
    );
  }
}

String _$appRouterHash() => r'9c438afc74a1a79b595c3b38d1f32aff136ecde8';
