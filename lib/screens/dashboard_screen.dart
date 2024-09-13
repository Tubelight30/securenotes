import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:securenotes/controller/login_controller.dart';
import 'package:securenotes/controller/logout_controller.dart';
import 'package:securenotes/controller/userprofile_controller.dart';
import 'package:securenotes/screens/onboard_screen.dart';

class DashBoardScreen extends StatelessWidget {
  UserProfileController userProfileController =
      Get.put(UserProfileController());
  LogoutController logoutController = Get.put(LogoutController());
  DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (userProfileController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(userProfileController.loggedInUser!.name),
              Text(userProfileController.loggedInUser!.email),
              Text(userProfileController.loggedInUser!.id),
              // Text(loginController.loggedInUser!.),
              ElevatedButton(
                onPressed: () async {
                  final ans = await logoutController.logout();
                  if (ans) {
                    Get.snackbar(
                      'Logout Successful',
                      'You have successfully logged out',
                      backgroundColor: Colors.black,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    Get.off(OnBoardScreen());
                  }
                },
                child: Text("Logout"),
              ),
              Center(
                child: Text("dashboard"),
              ),
            ],
          );
        },
      ),
    );
  }
}
