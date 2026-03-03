import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// スクリーンショット専用ドライバー
/// takeScreenshot() で撮影した PNG を assets/marketing/screenshots/ に保存する
Future<void> main() => integrationDriver(
      onScreenshot: (
        String name,
        List<int> bytes, [
        Map<String, Object?>? args,
      ]) async {
        final file = File('assets/marketing/screenshots/$name.png');
        await file.create(recursive: true);
        file.writeAsBytesSync(bytes);
        // ignore: avoid_print
        print('Screenshot saved: ${file.path}');
        return true;
      },
    );
