/// Minimal smoke test to verify device connectivity and basic app launch.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke: device connectivity check', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Text('Hello'))),
    );
    expect(find.text('Hello'), findsOneWidget);
  });
}
