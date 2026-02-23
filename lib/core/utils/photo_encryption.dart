import 'dart:io';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';

abstract final class PhotoEncryption {
  /// Encrypt bytes and save to file with .enc extension.
  static Future<String> encryptAndSave(
    Uint8List plainBytes,
    String destPath,
    Uint8List key,
  ) async {
    final cipher = HiveAesCipher(key);
    final maxLen = cipher.maxEncryptedSize(plainBytes);
    final out = Uint8List(maxLen);
    final actualLen =
        cipher.encrypt(plainBytes, 0, plainBytes.length, out, 0);
    final encrypted = Uint8List.view(out.buffer, 0, actualLen);

    final encPath = destPath.endsWith('.enc') ? destPath : '$destPath.enc';
    await File(encPath).writeAsBytes(encrypted);
    return encPath;
  }

  /// Decrypt from .enc file and return raw image bytes.
  static Future<Uint8List> decryptFromFile(
    String encPath,
    Uint8List key,
  ) async {
    final encrypted = await File(encPath).readAsBytes();
    final cipher = HiveAesCipher(key);
    final out = Uint8List(encrypted.length);
    final actualLen =
        cipher.decrypt(encrypted, 0, encrypted.length, out, 0);
    return Uint8List.view(out.buffer, 0, actualLen);
  }

  /// Check if a file path refers to an encrypted photo.
  static bool isEncrypted(String path) => path.endsWith('.enc');
}
