import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/constants/secrets.dart';
import 'package:securenotes/controller/appwrite_service.dart';

class SignUpController extends GetxController {
  final AppwriteService appwriteService = Get.find<AppwriteService>();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  // final Client client = Client();
  // late final Account account;

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

  Future<bool> signup(BuildContext context) async {
    isLoading = true;
    update();

    try {
      final user = await appwriteService.account.create(
        userId: ID.unique(),
        email: emailController.text,
        password: passwordController.text,
        // name: usernameController.text,
      );

      // show success SnackBar
      // Get.snackbar(
      //   'Registration Successful',
      //   'You have successfully registered',
      //   backgroundColor: Colors.black,
      //   colorText: Colors.white,
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      print("this da user");
      print(user);

      final database = appwriteService.database;

      await database.createDocument(
        collectionId: Secrets.usercollectionId,
        databaseId: Secrets.databaseId,
        documentId: user.$id,
        data: {
          'name': usernameController.text,
          'email': emailController.text,
        },
      );
      return true;
    } catch (e) {
      // show error SnackBar
      print(e.toString());
      Get.snackbar(
        'Registration Failedee',
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
