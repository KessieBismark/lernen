import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app_config.dart';

class EncryptionUtil {
  // Secure storage to save/load the key
  static const _storage = FlutterSecureStorage();
final key = AppConfig.encryptionKey;
  // AES key length must be 32 for AES-256, 16 for AES-128
  // static const _keyStorageKey =  key ;

  /// Generates & saves a random key if none exists
  static Future<Key> _getKey() async {
    String? storedKey = await _storage.read(key: AppConfig.encryptionKey);

    if (storedKey == null) {
      final key = Key.fromSecureRandom(32); // AES-256
      await _storage.write(key: AppConfig.encryptionKey, value: base64UrlEncode(key.bytes));
      return key;
    }

    return Key(base64Url.decode(storedKey));
  }

  /// Encrypts plaintext and returns a base64 encoded string.
  static Future<String> encryptString(String plainText) async {
    final key = await _getKey();
    final iv = IV.fromSecureRandom(16); // a new IV each time

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc)); // AES-CBC
    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // return combined IV + ciphertext (base64) — necessary for decrypt later
    final fullData = iv.bytes + encrypted.bytes;
    return base64Encode(fullData);
  }

  /// Decrypts a base64 encoded string back to plaintext.
  static Future<String> decryptString(String encryptedBase64) async {
    final key = await _getKey();

    // decode, extract IV and ciphertext
    final fullData = base64Decode(encryptedBase64);
    final iv = IV(fullData.sublist(0, 16));
    final cipherBytes = fullData.sublist(16);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = Encrypted(cipherBytes);

    return encrypter.decrypt(encrypted, iv: iv);
  }
}
