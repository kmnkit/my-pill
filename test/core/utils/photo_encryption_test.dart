import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kusuridoki/core/utils/photo_encryption.dart';

void main() {
  group('PhotoEncryption', () {
    late Uint8List testKey;
    late Directory tempDir;

    setUp(() {
      testKey = Uint8List.fromList(Hive.generateSecureKey());
      tempDir = Directory.systemTemp.createTempSync('photo_encryption_test_');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('encrypt and decrypt roundtrip produces identical bytes', () async {
      final originalBytes = Uint8List.fromList(
        List.generate(1024, (i) => i % 256),
      );
      final destPath = '${tempDir.path}/test_photo';

      final encPath = await PhotoEncryption.encryptAndSave(
        originalBytes,
        destPath,
        testKey,
      );

      expect(encPath, endsWith('.enc'));
      expect(File(encPath).existsSync(), isTrue);

      final decrypted = await PhotoEncryption.decryptFromFile(encPath, testKey);
      expect(decrypted, equals(originalBytes));
    });

    test('encrypted file differs from original bytes', () async {
      final originalBytes = Uint8List.fromList(List.generate(256, (i) => i));
      final destPath = '${tempDir.path}/test_photo2';

      final encPath = await PhotoEncryption.encryptAndSave(
        originalBytes,
        destPath,
        testKey,
      );

      final encryptedBytes = await File(encPath).readAsBytes();
      expect(encryptedBytes, isNot(equals(originalBytes)));
    });

    test('isEncrypted returns true for .enc files only', () {
      expect(PhotoEncryption.isEncrypted('/path/to/photo.enc'), isTrue);
      expect(PhotoEncryption.isEncrypted('/path/to/photo.jpg'), isFalse);
      expect(PhotoEncryption.isEncrypted('/path/to/photo.jpeg'), isFalse);
      expect(PhotoEncryption.isEncrypted('/path/to/photo.png'), isFalse);
      expect(PhotoEncryption.isEncrypted('/path/to/file'), isFalse);
    });

    test('encryptAndSave appends .enc to path without it', () async {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final destPath = '${tempDir.path}/no_ext_photo';

      final encPath = await PhotoEncryption.encryptAndSave(
        bytes,
        destPath,
        testKey,
      );

      expect(encPath, equals('$destPath.enc'));
    });

    test(
      'encryptAndSave preserves .enc extension if already present',
      () async {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final destPath = '${tempDir.path}/already.enc';

        final encPath = await PhotoEncryption.encryptAndSave(
          bytes,
          destPath,
          testKey,
        );

        expect(encPath, equals(destPath));
        expect(encPath, isNot(endsWith('.enc.enc')));
      },
    );

    test('roundtrip works with empty bytes', () async {
      final originalBytes = Uint8List(0);
      final destPath = '${tempDir.path}/empty_photo';

      final encPath = await PhotoEncryption.encryptAndSave(
        originalBytes,
        destPath,
        testKey,
      );

      final decrypted = await PhotoEncryption.decryptFromFile(encPath, testKey);
      expect(decrypted, equals(originalBytes));
    });

    test('roundtrip works with large payload (simulating real JPEG)', () async {
      // ~500KB simulated JPEG
      final originalBytes = Uint8List.fromList(
        List.generate(500 * 1024, (i) => i % 256),
      );
      final destPath = '${tempDir.path}/large_photo';

      final encPath = await PhotoEncryption.encryptAndSave(
        originalBytes,
        destPath,
        testKey,
      );

      final decrypted = await PhotoEncryption.decryptFromFile(encPath, testKey);
      expect(decrypted, equals(originalBytes));
    });
  });
}
