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
    r'72bd0a7c64713f0dfde9b9a89e9c22861a7dd881';

/// Notifier that fires when a warm-start invite code arrives via deep link.

@ProviderFor(inviteRefreshNotifier)
final inviteRefreshProvider = InviteRefreshNotifierProvider._();

/// Notifier that fires when a warm-start invite code arrives via deep link.

final class InviteRefreshNotifierProvider
    extends
        $FunctionalProvider<
          RouterRefreshNotifier,
          RouterRefreshNotifier,
          RouterRefreshNotifier
        >
    with $Provider<RouterRefreshNotifier> {
  /// Notifier that fires when a warm-start invite code arrives via deep link.
  InviteRefreshNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteRefreshProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteRefreshNotifierHash();

  @$internal
  @override
  $ProviderElement<RouterRefreshNotifier> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RouterRefreshNotifier create(Ref ref) {
    return inviteRefreshNotifier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouterRefreshNotifier value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouterRefreshNotifier>(value),
    );
  }
}

String _$inviteRefreshNotifierHash() =>
    r'066f0ef15b31d8692b436c5e588bdab24ba8aa86';

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

String _$appRouterHash() => r'7cb98fe2ce2ca1ed365268e418b782e4d73e11c9';
