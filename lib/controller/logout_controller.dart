import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/controller/note_controller.dart';

class LogoutController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  final NoteController noteController =
      Get.find<NoteController>(tag: 'note_controller');
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // initAppwrite();
  }

  // void initAppwrite() {
  //   client
  //       .setEndpoint(Secrets.endpoint) // Your API Endpoint
  //       .setProject(Secrets.projId); // Your project ID

  //   account = Account(client);
  // }

  Future<bool> logout() async {
    isLoading.value = true;
    update();
    try {
      appwriteService.account.deleteSession(sessionId: 'current');
      noteController.notes.clear();
      return true;
    } catch (e) {
      // Show error SnackBar
      Get.snackbar(
        'Logout Failed',
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
