// import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';
import 'package:securenotes/models/user.dart';

class LoginController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final isLogin = false.obs;
  final isLoading = false.obs;
  User? loggedInUser;

  @override
  void onInit() {
    super.onInit();
    // initAppwrite();
  }

  Future<bool> login() async {
    isLoading.value = true;
    update();
    try {
      print("this da email");
      print(emailController.text);
      await appwriteService.account.createEmailPasswordSession(
        email: emailController.text,
        password: passwordController.text,
      );
      print("this da user");
      // final user = await appwriteService.account.get();
      // await fetchUserDetails(user.$id);
      return true;
    } catch (e) {
      // Show error SnackBar
      Get.snackbar(
        'Login Failed',
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

  // Future<void> fetchUserDetails(String userId) async {
  //   try {
  //     final document = await appwriteService.database.getDocument(
  //         databaseId: Secrets.databaseId,
  //         collectionId: Secrets.usercollectionId,
  //         documentId: userId);

  //     loggedInUser = User.fromMap(document.data);
  //   } catch (e) {
  //     Get.snackbar(
  //       "Fetch User Details Failed",
  //       e.toString(),
  //       backgroundColor: Colors.black,
  //       colorText: Colors.white,
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }
}
