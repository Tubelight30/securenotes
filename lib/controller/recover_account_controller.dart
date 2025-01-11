// recover_account_controller.dart

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/utils/encryption_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:securenotes/controller/note_controller.dart';

class RecoverAccountController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  // final NoteController noteController = Get.put(NoteController());

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passphraseController = TextEditingController();
  bool isLoading = false;
  Future<bool> recoverAccount() async {
    try {
      isLoading = true;
      update();
      // Authenticate user
      await appwriteService.account.createEmailPasswordSession(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      // Generate new encryption key
      final passphrase = passphraseController.text;
      final newEncryptionKey =
          EncryptionUtils.generateEncryptionKey(passphrase);

      // Store the new encryption key
      final user = await appwriteService.account.get();
      final result = await appwriteService.database.listDocuments(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.notesCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.limit(1),
        ],
      );

      if (result.documents.isEmpty) {
        // If user has no notes, we can safely update the key
        // since there's nothing to decrypt
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('encryption_key', newEncryptionKey);
        return true;
      }
      try {
        final note = result.documents.first;
        final encryptedTitle = note.data['title'] as String;

        // Attempt to decrypt - this will throw an error if the passphrase is wrong
        EncryptionUtils.decrypt(encryptedTitle, newEncryptionKey);

        // If decryption succeeded, save the new key
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('encryption_key', newEncryptionKey);

        return true;
      } catch (e) {
        Get.snackbar(
          'Recovery Failed',
          'Incorrect passphrase. Please enter the original passphrase used to encrypt your notes.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        await appwriteService.account.deleteSession(sessionId: 'current');
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Recovery Failedee recovercontrl',
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
}
