// import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/models/user.dart';

class UserProfileController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  // final isLogin = false.obs;
  final isLoading = false.obs;
  User? loggedInUser;

  @override
  void onInit() {
    super.onInit();
    // initAppwrite();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    isLoading.value = true;
    update();
    try {
      final user = await appwriteService.account.get();
      final document = await appwriteService.database.getDocument(
        databaseId: Secrets.databaseId,
        collectionId: Secrets.usercollectionId,
        documentId: user.$id,
      );
      loggedInUser = User.fromMap(document.data);
    } catch (e) {
      Get.snackbar(
        "Fetch User Details Failed",
        e.toString(),
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
