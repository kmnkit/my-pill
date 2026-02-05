/// Firebase mock setup for integration tests
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Setup Firebase mocks for integration testing
void setupFirebaseCoreMocks() {
  // Don't call TestWidgetsFlutterBinding - it conflicts with IntegrationTestWidgetsFlutterBinding
  // IntegrationTestWidgetsFlutterBinding will be initialized by the caller

  // Initialize timezone database (required for onboarding screen)
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/New_York'));

  // Setup mock method channel for Firebase Core
  const MethodChannel channel = MethodChannel(
    'plugins.flutter.io/firebase_core',
  );

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeCore') {
      return [
        {
          'name': '[DEFAULT]',
          'options': {
            'apiKey': 'test-api-key',
            'appId': 'test-app-id',
            'messagingSenderId': 'test-sender-id',
            'projectId': 'test-project-id',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (methodCall.method == 'Firebase#initializeApp') {
      return {
        'name': methodCall.arguments['appName'] ?? '[DEFAULT]',
        'options': methodCall.arguments['options'] ?? {},
        'pluginConstants': {},
      };
    }
    return null;
  });
}
