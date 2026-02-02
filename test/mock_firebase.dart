import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void setupFirebaseCoreMocks() {
  setupFirebaseCoreMocksInternal();
}

void setupFirebaseCoreMocksInternal() {
  FirebasePlatform.instance = _MockFirebasePlatform();
}

class _MockFirebasePlatform extends FirebasePlatform {
  _MockFirebasePlatform() : super();

  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return _MockFirebaseAppPlatform(name);
  }

  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return _MockFirebaseAppPlatform(name ?? defaultFirebaseAppName);
  }

  @override
  List<FirebaseAppPlatform> get apps => [_MockFirebaseAppPlatform(defaultFirebaseAppName)];
}

class _MockFirebaseAppPlatform extends FirebaseAppPlatform {
  _MockFirebaseAppPlatform(String name)
      : super(
          name,
          const FirebaseOptions(
            apiKey: 'test-api-key',
            appId: 'test-app-id',
            messagingSenderId: 'test-sender-id',
            projectId: 'test-project-id',
          ),
        );

  @override
  bool get isAutomaticDataCollectionEnabled => false;
}
