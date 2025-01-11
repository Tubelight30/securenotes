// import 'package:encrypt/encrypt.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class EncryptionUtils {
//   static const String _encryptionKeyPref = 'encryption_key';

//   static Future<String> getEncryptionKey() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? key = prefs.getString(_encryptionKeyPref);
//     if (key == null) {
//       key = generateEncryptionKey();
//       await prefs.setString(_encryptionKeyPref, key);
//     }
//     print("this da key" + key);
//     return key;
//   }

//   static String generateEncryptionKey() {
//     final key = Key.fromSecureRandom(32);
//     return key.base64;
//   }

//   static String encrypt(String plainText, String keyString) {
//     final key = Key.fromBase64(keyString);
//     final iv = IV.fromLength(16);
//     final encrypter = Encrypter(AES(key));
//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return encrypted.base64;
//   }

//   static String decrypt(String encryptedText, String keyString) {
//     final key = Key.fromBase64(keyString);
//     final iv = IV.fromLength(16);
//     final encrypter = Encrypter(AES(key));
//     final encrypted = Encrypted.fromBase64(encryptedText);
//     return encrypter.decrypt(encrypted, iv: iv);
//   }
// }
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncryptionUtils {
  static const String _encryptionKeyPref = 'encryption_key';

  static Future<String> getEncryptionKey() async {
    final prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString(_encryptionKeyPref);
    if (key == null) {
      throw Exception('Encryption key not found');
    }
    return key;
  }

  static String generateEncryptionKey(String passphrase) {
    final bytes = utf8.encode(passphrase);
    final digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
    // final key = Key.fromSecureRandom(32); // 32 bytes for AES-256
    // return key.base64;
  }

  static String encrypt(String plainText, String keyString) {
    final key = Key.fromBase64(keyString);
    final iv = IV.fromSecureRandom(16); // Generate a random IV
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    // Combine the IV and the encrypted text (both in base64)
    return iv.base64 + encrypted.base64; // Store IV with the ciphertext
  }

  static String decrypt(String encryptedTextWithIV, String keyString) {
    final key = Key.fromBase64(keyString);

    // Extract the IV from the beginning of the encrypted text
    final ivBase64 = encryptedTextWithIV.substring(
        0, 24); // First 24 characters for IV (16 bytes in base64)
    final encryptedBase64 = encryptedTextWithIV
        .substring(24); // Remaining part is the encrypted text

    final iv = IV.fromBase64(ivBase64);
    final encrypter = Encrypter(AES(key));

    final encrypted = Encrypted.fromBase64(encryptedBase64);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}




















  // static void testing() {
  //   final bytes = utf8.encode("saumya");
  //   print("this is the bytes" + bytes.toString());
  //   final digest = sha256.convert(bytes);
  //   print("this is the digest" + digest.toString());
  //   final base = base64.encode(digest.bytes);
  //   print("this is the base" + base.toString());
  // }